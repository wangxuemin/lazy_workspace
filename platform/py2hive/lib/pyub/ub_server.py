import socket, select, threading
import traceback, signal, time
import struct, mcpack

from nshead import nshead
from ub_log import log
from ub_misc import ub_timer, ub_auth

class ub_server():

	thread_data = {}

	def __init__(self, cfg):
		self.name = cfg["name"]
		self.port = cfg["port"]
		self.threadnum = cfg["threadnum"]
		self.rdtmout = cfg["readtimeout"]
		self.wrtmout = cfg["writetimeout"]
		self.conntype = cfg["connecttype"]
		self.auth = ub_auth()

		self.auth.load_ip(cfg["auth"])
		self.pool = ub_epoll()

		self.callback = self.empty_callback
		self.init_callback = None

		self.backlog_queue_max_size = 1024

	def run(self):

		# init server socket (create, bind, listen, setopt)
		self.listen_fd = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
		self.listen_fd.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
		self.listen_fd.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
		self.listen_fd.bind(('', self.port))
		self.listen_fd.listen(self.backlog_queue_max_size)
		self.listen_fd.setblocking(0)

		self.pool.run(self)

	def stop(self):
		self.pool.stop()

	def join(self):
		self.pool.join()

	@staticmethod
	def empty_callback(req):
		return {}

	def set_callback(self, cb):
		self.callback = cb

	def set_init_callback(self, cb):
		self.init_callback = cb
	
	@classmethod
	def set_thread_data(cls, key, value):
		pid = threading.current_thread().ident
		if not pid:
			return

		if pid not in cls.thread_data:
			cls.thread_data[pid] = {}

		cls.thread_data[pid][key] = value
	
	@classmethod
	def get_thread_data(cls, key):
		pid = threading.current_thread().ident
		if not pid:
			return None

		if pid not in cls.thread_data:
			return None

		if key not in cls.thread_data[pid]:
			return None

		return cls.thread_data[pid][key]


class ub_epoll():

	def __init__(self):

		self.connections = []
		self.conncond = threading.Condition()
		self.running = False
	
	def run(self, server):
		self.server = server
		self.running = True
		
		#print 'run __main thread'
		self.main = threading.Thread(target = self.__main)
		#self.main.setDeamon(1)
		self.main.start()

		#print 'run __works threads'
		self.twork = []
		for i in range(self.server.threadnum):
			self.twork.append(threading.Thread(target = self.__work))
		for i in range(self.server.threadnum):
			self.twork[i].start()

	def stop(self):
		self.running = False

	def join(self):

		while self.running:
			time.sleep(1000000)

		self.main.join()
		for i in range(self.server.threadnum):
			self.twork[i].join()

	def __add_event(self, fd):
		self.epoll.register(fd, select.EPOLLIN | select.EPOLLHUP | select.EPOLLERR)

	def __del_event(self, fd):
		self.epoll.unregister(fd)

	def __produce(self):
	
		try:
			ready_list = self.epoll.poll(1)
		except IOError, e:
			if e.errno == errno.EINTR:
				return

		for fd, events in ready_list:
			if fd == self.server.listen_fd.fileno():
				#print 'receive a connection.[fd:%d]' % fd
				#conn, addr = self.server.listen_fd.accept()
				connection = self.server.listen_fd.accept()
				conn, addr = connection

				if self.server.auth.auth_str(addr[0]):
					self.__add_event(conn.fileno())
					self.conn[conn.fileno()] = connection
				else:
					log.warning("invalid ip[%s]", addr[0])
					del(connection)
			elif select.EPOLLHUP & events:
				log.warning("EPOLLHUP close socket[%d]", fd)
				self.__del_event(fd)
				del(self.conn[fd])
			elif select.EPOLLERR & events:
				log.warning("EPOLLERR close socket[%d]", fd)
				del(self.conn[fd])
			elif select.EPOLLIN & events:
				self.__del_event(fd)
				self.__put_conn(self.conn[fd])
				
	def __consume(self, handler):

		pid = threading.current_thread().ident
		#print 'pid %d, consume read!' % pid

		conn = self.__get_conn()

		#print 'get conn, consume pid %d' % pid
		if not conn:
			return

		try:
			#print 'handle conn, pid %d' % pid
			handler.handle(conn)
			if self.server.conntype:
				self.__add_event(conn[0].fileno())
				#conn[0].close()
			else:
				conn[0].close()
		except socket.error, why:
			log.warning("socket[%d] %s", conn[0].fileno(), why)
			conn[0].close()
		except Exception, why:
			stack_info = traceback.format_exc()
			log.warning("unknown error: %s", why)
			log.warning("stack info: \n%s", stack_info)

	def __main(self):
		
		log.init_thread()
		self.epoll = select.epoll()
		self.__add_event(self.server.listen_fd.fileno())

		self.conn = {}
		
		while self.running:
			self.__produce()

	def __work(self):

		log.init_thread()
		handler = nshead_handler(self.server)

		if self.server.init_callback:
			self.server.init_callback()

		while self.running:
			self.__consume(handler)

	def __get_conn(self):
		self.conncond.acquire()
		while len(self.connections) == 0 and self.running:
			self.conncond.wait(1)
		if not self.running:
			self.conncond.release()
			return None
		conn = self.connections.pop(0)
		self.conncond.release()

		return conn

	def __put_conn(self, conn):
		self.conncond.acquire()
		self.connections.append(conn)
		self.conncond.notify()
		self.conncond.release()

class nshead_handler():

	def __init__(self, server):
		self.server = server
		self.nshead = nshead()

	def __recv(self, sock, size):
		read = 0
		buf = ""
		while read < size:
			rbuf = sock.recv(size - read)
			if not rbuf:
				break
			buf += rbuf
			read += len(rbuf)

		return buf

	def handle(self, conn):

		sock, addr = conn
		timer = ub_timer()

		# recv
		timer.settask("rev")
		sock.settimeout(self.server.rdtmout)
		head = self.__recv(sock, self.nshead.size)
		if len(head) == 0:
			raise socket.error("connection reset by peer")
		self.nshead.frombin(head)

		log.setlogid(self.nshead.log_id)
		log.setreqip("%s", addr[0])

		#print 'ready to receive body'

		body = self.__recv(sock, self.nshead.body_len)
		if len(body) != self.nshead.body_len:
			raise socket.error("read body failed")
		req = mcpack.loads(body)

		# callback
		timer.settask("proc")
		if self.nshead.provider != "__MONITOR__":
			#print 'ready to callback'
			#print 'req: %s' % str(req)
			resp = self.server.callback(req)
			#print 'response: %s' % str(resp)

			rpack = mcpack.dumps(resp)
			rhead = self.nshead
			rhead.provider = self.server.name
			rhead.body_len = len(rpack)
			rbuf = rhead.tobin() + rpack

		else:
			#print 'enter in !!!!'
			log.trace("receive a monitor request with nshead provider '__MONITOR__'.");
			rhead = self.nshead
			rhead.provider = self.server.name
			rhead.body_len = 0
			rbuf = rhead.tobin()

		# send
		timer.settask("write")
		sock.settimeout(self.server.wrtmout)
		sock.sendall(rbuf)

		timer.endtask()
		log.setproctime("total:%u(ms) rev:%u+proc:%u+write:%u",
				timer.gettotal(), timer.gettask("rev"),
				timer.gettask("proc"), timer.gettask("write"))
		log.notice("")

#/* vim: set ts=4 sw=4 sts=4 tw=100 */
