#! /usr/local/bin/python

from nshead import nshead
from ub_server import ub_server
from ub_conf import ub_conf
from ub_log import log

import time, signal

server = None

def demo_callback(req):
	resp = {"hello":"world", "arr":[1,2,3,4,5]}
	resp["test1"] = 123
	resp["test2"] = -234
	resp["test3"] = 111111111111111111L
	resp["test4"] = -111111111111111111L
	resp["test5"] = "test"
	resp["test6"] = ["123", 1234, -345]
	resp["test7"] = {'test1': "bdc", 'test2': 123, 'test3': -234}

	log.pushnotice("[cmd:%s] ok", req["cmd"])

	return resp

def stop_server(signum, frame):
	print 'stop by signal %d' % signum
	global server
	server.stop()

conf = ub_conf('conf', 'demo.conf')
g_conf = {"svr" : conf.get_svr("resys", "demo")}

logpath = conf.get_str("log_dir")
logfile = conf.get_str("log_file")
logsize = conf.get_int("log_size")
loglevel = conf.get_int("log_level")
log.init("demo", logpath, logfile, logsize, loglevel)

signal.signal(signal.SIGINT, stop_server)
signal.signal(signal.SIGTERM, stop_server)

server = ub_server(g_conf["svr"])
server.set_callback(demo_callback)
server.run()
server.join()

