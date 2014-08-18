import time
import socket
import struct

class ub_timer():
	def __init__(self):
		self.tasks = []

	def settask(self, name):
		self.tasks.append((name, time.time()))

	def endtask(self):
		self.tasks.append((None, time.time()))

	def gettask(self, name):
		for i in range(len(self.tasks)):
			if self.tasks[i][0] == name:
				return (self.tasks[i + 1][1] - self.tasks[i][1]) * 1000
		return 0

	def gettotal(self):
		n = len(self.tasks)
		if n == 0:
			return 0
		return (self.tasks[n - 1][1] - self.tasks[0][1]) * 1000

class ub_auth():

	# ip format:
	#	127.*.*.*
	#	127.0.0.1
	#	10.0.10.1-10.1.11.1

	def __init__(self):
		self.innocent_list = []

	def ip2int(self, ipstr):
		return struct.unpack("!I", socket.inet_aton(ipstr))[0]

	def int2ip(self, ip):
		return socket.inet_ntoa(struct.pack("!I", ip))

	def load_ip(self, file):
		f = open(file, 'r')
		line = f.readline()
		while line:
			ip = line.strip()
			if len(ip) > 0:
				self.push_ip(ip)
			line = f.readline()

	def push_ip(self, ip):
		ips = ip.split('-')
		if len(ips) == 1:
			try:
				ipint = self.ip2int(ips[0])
				ipsec = (ipint, ipint)
			except socket.error:
				# 127.*.*.*
				dl = ips[0].split('.')
				dr = [0, 0, 0, 0]
				for i in range(4):
					if dl[i] == '*':
						dl[i] = "0"
						dr[i] = "255"
					else:
						dr[i] = dl[i]
				ipsec = (self.ip2int('.'.join(dl)), self.ip2int('.'.join(dr)))

		else:
			# 10.0.10.1-10.1.11.1
			ipsec = (self.ip2int(ips[0]), self.ip2int(ips[1]))
		self.innocent_list.append(ipsec)

	def auth_str(self, ipstr):
		ip = self.ip2int(ipstr)
		for i in range(len(self.innocent_list)):
			if self.innocent_list[i][0] <= ip and ip <= self.innocent_list[i][1]:
				return True
		return False

	def auth_int(self, ip):
		for i in range(len(self.innocent_list)):
			if self.innocent_list[i][0] <= ip and ip <= self.innocent_list[i][1]:
				return True
		return False

