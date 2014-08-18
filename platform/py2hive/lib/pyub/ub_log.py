import os, sys, threading
import traceback
from time import localtime, strftime

class ub_log():

	__LOG_FATAL = 1
	__LOG_WARNING = 2
	__LOG_NOTICE = 4
	__LOG_TRACE = 8
	__LOG_DEBUG = 16

	__LEVEL_STRING = {__LOG_FATAL : "FATAL",
					  __LOG_WARNING : "WARNING",
					  __LOG_NOTICE : "NOTICE",
					  __LOG_TRACE : "TRACE",
					  __LOG_DEBUG : "DEBUG"}

	def __init__(self):
		self.name = "ub_log"
		self.logfile = "<stderr>"
		self.wflogfile = "<stderr>"
		self.max_size = 0
		self.log_level = 16

		self.log = sys.stderr
		self.wflog = sys.stderr

		self.logid = {}
		self.reqip = {}
		self.proctime = {}
		self.notice_buffer = {}

		pid = self.__get_pid()
		self.notice_buffer[pid] = ""
		self.logid[pid] = 0
		self.reqip[pid] = "127.0.0.1"
		self.proctime[pid] = ""

	def __get_pid(self):
		pid = threading.current_thread().ident
		if not pid:
			pid = os.getpid()

		return pid

	def init(self, name = "ub_log", path = "./log", file = "ub_log",
			max_size = 1000, log_level = 16):
		self.name = name
		self.logfile = path + '/' + file + "log"
		self.wflogfile = path + '/' + file + "log.wf"
		self.max_size = max_size * 1024 * 1024
		self.log_level = log_level

		self.log = open(self.logfile, "a+")
		self.wflog = open(self.wflogfile, "a+")

		buf = strftime("%Y-%m-%d %H:%M:%S:", localtime())
		pid = self.__get_pid()
		self.notice_buffer[pid] = ""
		buf += ' ' + self.name + ' * %lu' % pid

		self.log.write(buf + " Open process log by----%s\n=================================================\n" % self.name)
		self.log.flush()
		self.wflog.write(buf + " Open process log by----%s for wf\n=================================================\n" % self.name)
		self.wflog.flush()

	def init_thread(self):

		buf = strftime("%Y-%m-%d %H:%M:%S:", localtime())
		pid = self.__get_pid()
		self.notice_buffer[pid] = ""
		buf += ' ' + self.name + ' * %lu' % pid

		self.log.write(buf + " Open thread log by----%s\n=================================================\n" % self.name)
		self.log.flush()
		self.wflog.write(buf + " Open thread log by----%s for wf\n=================================================\n" % self.name)
		self.wflog.flush()

	def __check_file(self, fp, buf):
		if fp.name.startswith('<'):
			return fp

		try:
			st = os.stat(fp.name)
			if st.st_size + len(buf) > self.max_size:
				fp.truncate(0)

		except OSError:
			name = fp.name
			fp.close()
			fp = open(name, "a+")

		return fp
	
	def __write_log(self, level, msg):

		stack  = traceback.extract_stack()
		depth = len(stack)
		file_name = stack[depth-3][0]
		line_number = stack[depth-3][1]

		buf = self.__LEVEL_STRING[level] + ": "
		buf += strftime("%Y-%m-%d %H:%M:%S:", localtime())
		pid = self.__get_pid()
		buf += ' ' + self.name + ' * %lu' % pid
		buf += ' [logid:%u][reqip:%s]' % (self.getlogid(), self.getreqip())
		buf += ' [%s:%d]' % (file_name, line_number)
		buf += ' ' + msg + '\n'

		if level <= self.__LOG_WARNING:
			log = self.wflog = self.__check_file(self.wflog, buf)
		else:
			log = self.log = self.__check_file(self.log, buf)

		log.write(buf)
		log.flush()

	def debug(self, fmt, *args):
		if self.log_level < self.__LOG_DEBUG:
			return
		self.__write_log(self.__LOG_DEBUG, fmt % args)

	def trace(self, fmt, *args):
		if self.log_level < self.__LOG_TRACE:
			return
		self.__write_log(self.__LOG_TRACE, fmt % args)

	def notice(self, fmt, *args):
		if self.log_level < self.__LOG_NOTICE:
			return
		pid = self.__get_pid()
		msg = "[proctime:%s]" % self.proctime[pid]
		msg += self.notice_buffer[pid] + fmt % args
		self.__write_log(self.__LOG_NOTICE, msg)
		self.clearnotice()

	def warning(self, fmt, *args):
		if self.log_level < self.__LOG_WARNING:
			return
		self.__write_log(self.__LOG_WARNING, fmt % args)

	def fatal(self, fmt, *args):
		if self.log_level < self.__LOG_FATAL:
			return
		self.__write_log(self.__LOG_FATAL, fmt % args)

	def pushnotice(self, fmt, *args):
		pid = self.__get_pid()
		self.notice_buffer[pid] += fmt % args

	def clearnotice(self):
		pid = self.__get_pid()
		self.notice_buffer[pid] = ""

	def setlogid(self, logid):
		pid = self.__get_pid()
		self.logid[pid] = logid

	def getlogid(self):
		pid = self.__get_pid()
		if pid in self.logid:
			return self.logid[pid]
		return 0

	def setreqip(self, fmt, *args):
		pid = self.__get_pid()
		self.reqip[pid] = fmt % args

	def getreqip(self):
		pid = self.__get_pid()
		if pid in self.reqip:
			return self.reqip[pid]
		return '0.0.0.0'

	def setproctime(self, fmt, *args):
		pid = self.__get_pid()
		self.proctime[pid] = fmt % args

log = ub_log()

