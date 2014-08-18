import socket, threading
import random

from nshead import nshead
from ub_log import log

class ub_client():

	def __init__(self, reqsvr):
		self.name = reqsvr["name"]
		self.ip = reqsvr["ip"]
		self.port = reqsvr["port"]
		self.rdtmout = reqsvr["readtimeout"]
		self.wrtmout = reqsvr["writetimeout"]
		self.cntmout = reqsvr["connecttimeout"]
		self.conntype = reqsvr["connecttype"]
		self.maxconn = reqsvr["maxconnect"]
		self.retry = reqsvr["retry"]

		self.sockets = []
		self.socket_num = 0
		self.sockcond = threading.Condition()

		random.seed()

	def __connect(self):
		if self.hashkey < 0:
			self.hashkey = random.randint(0, len(self.ip) - 1)
		ip = self.ip[self.hashkey % len(self.ip)]
		try:
			sock = socket.create_connection((ip, self.port), self.cntmout)
		except socket.error, why:
			log.warning("connect error (%s)", why)
			return None

		return sock

	def __recv(self, sock, size):
		read = 0
		buf = ""
		while read < size:
			rbuf = sock.recv(size - read)
			if len(rbuf) == 0:
				break
			buf += rbuf
			read += len(rbuf)

		return buf

	def __get_socket(self):
		self.sockcond.acquire()
		while len(self.sockets) == 0 and self.socket_num >= self.maxconn:
			self.sockcond.wait(1)
		if len(self.sockets) == 0:
			for i in range(self.retry):
				sock = self.__connect()
				if sock:
					break
				log.warning("connect failed, retry[%d]", i)
			if sock:
				self.socket_num += 1
		else:
			sock = self.sockets.pop(0)
		self.sockcond.release()

		return sock

	def __put_socket(self, sock):
		self.sockcond.acquire()
		if not sock:
			self.socket_num -= 1
		elif self.conntype:
			self.sockets.append(sock)
		else:
			sock.close()
			self.socket_num -= 1
		self.sockcond.notify()
		self.sockcond.release()

	def invite(self, head, body, hashkey = -1):
		self.hashkey = hashkey
		sock = self.__get_socket()
		if not sock:
			log.warning("ub_client: connect to %s failed", self.name)
			return None

		rhead = None
		rbuf = None
		for i in range(self.retry):
			try:
				req = head.tobin() + body
				sock.settimeout(self.wrtmout)
				sock.sendall(req)

				sock.settimeout(self.rdtmout)
				rhead = nshead()
				rbuf = self.__recv(sock, rhead.size)
				if len(rbuf) == 0:
					raise socket.error("connection reset by peer")
				rhead.frombin(rbuf)
				rbuf = self.__recv(sock, rhead.body_len)
				if len(rbuf) != rhead.body_len:
					raise socket.error("recv body failed")
				break

			except socket.error, why:
				log.warning("socket error (%s), retry[%d]", why, i)
				sock.close()
				self.__put_socket(None)
				sock = self.__get_socket()
				if not sock:
					log.warning("ub_client: connect to %s failed", self.name)
					return None

		self.__put_socket(sock)

		return (rhead, rbuf)

