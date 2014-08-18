import socket
import threading
import time, sys

from nshead import nshead
from ub_conf import ub_conf
from ub_client import ub_client
from ub_log import log
import mcpack

conf = ub_conf("conf", "demo.conf")
reqsvr = conf.get_reqsvr("resys", "demo")
cli = ub_client(reqsvr)

THREADNUM = 1
COUNT = 200

def thread_work():
	head = nshead()
	pack = mcpack.dumps({"cmd":"test"})
	for i in range(COUNT):
		head.log_id = 1234560000 + i
		head.body_len = len(pack)

		resp = cli.invite(head, pack)

		if not resp:
			log.warning("ub_client invite error")
			time.sleep(1)

		(h, body) =  resp
		print mcpack.loads(body)

		#time.sleep(0.02)

twork = []
for i in range(THREADNUM):
	twork.append(threading.Thread(target = thread_work))

for i in range(THREADNUM):
	twork[i].start()

for i in range(THREADNUM):
	try:
		twork[i].join()
	except KeyboardInterrupt:
		sys.exit(0)

