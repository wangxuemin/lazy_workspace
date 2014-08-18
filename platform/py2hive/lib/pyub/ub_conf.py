
class ub_conf():

	class error(Exception):pass

	def __init__(self, dir, file):
		self.__all = {}

		try:
			fp = open(dir + '/' + file, 'r')
		except IOError:
			raise self.error("file not exist")

		try:
			line = fp.readline()
			while line:
				line = line.strip()
				if len(line) > 0 and not line.startswith('#'):
					(key, value) = line.split(':', 1)
					self.__all[key.strip()] = value.strip()
				line = fp.readline()
		except ValueError:
			raise self.error("format error")

		fp.close()

	def get_svr(self, pro, mod):
		svr = {}

		conf_name = pro + '_' + mod

		svr_name = "_svr_%s_name" % conf_name
		if svr_name not in self.__all:
			raise self.error("not found")
		svr["name"] = self.__all[svr_name]

		svr_port = "_svr_%s_port" % conf_name
		if svr_port not in self.__all:
			raise self.error("not found")
		svr["port"] = int(self.__all[svr_port])

		svr_readtimeout = "_svr_%s_readtimeout" % conf_name
		if svr_readtimeout not in self.__all:
			raise self.error("not found")
		svr["readtimeout"] = float(self.__all[svr_readtimeout]) / 1000

		svr_writetimeout = "_svr_%s_writetimeout" % conf_name
		if svr_writetimeout not in self.__all:
			raise self.error("not found")
		svr["writetimeout"] = float(self.__all[svr_writetimeout]) / 1000

		svr_threadnum = "_svr_%s_threadnum" % conf_name
		if svr_threadnum not in self.__all:
			raise self.error("not found")
		svr["threadnum"] = int(self.__all[svr_threadnum])

		svr_connecttype = "_svr_%s_connecttype" % conf_name
		if svr_connecttype not in self.__all:
			raise self.error("not found")
		svr["connecttype"] = int(self.__all[svr_connecttype])

		svr_auth = "_svr_%s_auth" % conf_name
		if svr_auth not in self.__all:
			raise self.error("not found")
		svr["auth"] = self.__all[svr_auth]

		return svr

	def get_reqsvr(self, pro, mod):
		svr = {}

		conf_name = pro + '_' + mod

		svr_name = "_reqsvr_%s_name" % conf_name
		if svr_name not in self.__all:
			raise self.error("not found")
		svr["name"] = self.__all[svr_name]

		svr_ip = "_reqsvr_%s_ip" % conf_name
		if svr_ip not in self.__all:
			raise self.error("not found")
		svr["ip"] = self.__all[svr_ip].split(' ')

		svr_port = "_reqsvr_%s_port" % conf_name
		if svr_port not in self.__all:
			raise self.error("not found")
		svr["port"] = int(self.__all[svr_port])

		svr_readtimeout = "_reqsvr_%s_readtimeout" % conf_name
		if svr_readtimeout not in self.__all:
			raise self.error("not found")
		svr["readtimeout"] = float(self.__all[svr_readtimeout]) / 1000

		svr_writetimeout = "_reqsvr_%s_writetimeout" % conf_name
		if svr_writetimeout not in self.__all:
			raise self.error("not found")
		svr["writetimeout"] = float(self.__all[svr_writetimeout]) / 1000

		svr_connecttimeout = "_reqsvr_%s_connecttimeout" % conf_name
		if svr_connecttimeout not in self.__all:
			raise self.error("not found")
		svr["connecttimeout"] = float(self.__all[svr_connecttimeout]) / 1000

		svr_maxconnect = "_reqsvr_%s_maxconnect" % conf_name
		if svr_maxconnect not in self.__all:
			raise self.error("not found")
		svr["maxconnect"] = int(self.__all[svr_maxconnect])

		svr_retry = "_reqsvr_%s_retry" % conf_name
		if svr_retry not in self.__all:
			raise self.error("not found")
		svr["retry"] = int(self.__all[svr_retry])

		svr_connecttype = "_reqsvr_%s_connecttype" % conf_name
		if svr_connecttype not in self.__all:
			raise self.error("not found")
		svr["connecttype"] = int(self.__all[svr_connecttype])

		return svr

	def get_str(self, name):
		if name in self.__all:
			return self.__all[name]
		raise self.error("not found")

	def get_int(self, name):
		if name in self.__all:
			return int(self.__all[name])
		raise self.error("not found")

	def get_float(self, name):
		if name in self.__all:
			return float(self.__all[name])
		raise self.error("not found")

