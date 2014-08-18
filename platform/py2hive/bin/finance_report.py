# encoding: utf-8

import os,sys,time,datetime,threading
import pdb,traceback
import MySQLdb

sys.path.append(os.getcwd())
sys.path.append(os.getcwd()+ '/conf')
sys.path.append(os.getcwd()+ '/lib')
sys.path.append(os.getcwd()+ '/task')

from hive_service import ThriftHive
from hive_service.ttypes import HiveServerException
from thrift import Thrift
from thrift.transport import TSocket
from thrift.transport import TTransport
from thrift.protocol import TBinaryProtocol
from pyub.ub_log import ub_log as Log
import conf

###################
# 全局变量区
#cwd=os.getcwd()

if len(sys.argv)>2:
    # 指定日期
    year=sys.argv[1]
    month=sys.argv[2]
else:
    # 默认上月
    workday=datetime.date.today()
    onemonth=datetime.timedelta(days=28)
    workday=workday-onemonth

year  = workday.strftime("%Y")
month = workday.strftime("%m")

# 获取昨天日期，选择最近的hive分区
today=datetime.date.today()
oneday=datetime.timedelta(days=1)
yesterday=today-oneday

hp_year  = yesterday.strftime("%Y")
hp_month = yesterday.strftime("%m")
hp_day   = yesterday.strftime("%d")

#print "%s %s %s" %( hp_year, hp_month, hp_day )

statMonth = "%s-%s" %(year,month)
print "logMonth is %s" %statMonth

def updateTable( statDate, area, colname, colvalue ):
    
    sql="""
        SELECT * FROM finance_report WHERE statDate='%s' AND area=%s
        """ %( statDate, area )
    mysclient.execute( sql )
    rows=mysclient.fetchall()
    
    # 存在 update
    if rows:
        sql="""
        UPDATE finance_report SET %s=%s 
        WHERE statDate='%s' AND area=%s 
        """ %( colname, colvalue, statDate, area )

    # 不存在 insert
    else:
        sql="""
    	INSERT INTO finance_report ( statDate, area, %s ) 
    	VALUES ( '%s', %s, %s )
    	""" %( colname, statDate, area, colvalue )
    	
    try:
        print sql
        mysclient.execute( sql )
        mysconn.commit()
    except Exception,e:
        print e
    
    return
    
#updateTable( '%s-%s-01' %( year,month ),0, 'drivernum', 1001)

print "Connect to HIVE Server %s:%s" %(conf.HIVE_HOST,conf.HIVE_PORT)
try:
    transport = TSocket.TSocket( conf.HIVE_HOST, conf.HIVE_PORT )
    transport = TTransport.TBufferedTransport( transport )
    protocol = TBinaryProtocol.TBinaryProtocol( transport )
    client = ThriftHive.Client( protocol )
except Exception,e:
    print e
    sys.exit(1)
    
transport.open()

client.execute( "use pdw" )

# 订单 统计 #order 增量
hql="""
SELECT (CASE WHEN area IS NULL THEN '10000' ELSE area END),
COUNT(*) cnt,
SUM(CASE WHEN status IN(1,2,3) THEN 1 
       WHEN status=4 AND driverid>0 THEN 1 
       ELSE 0 END 
  ) succcnt FROM dw_order 
WHERE year='%s' AND month='%s' 
GROUP BY area GROUPING SETS (area,())
""" %( year, month )

print hql
client.execute( hql )
rows = client.fetchAll()

try:
    mysconn=MySQLdb.connect( host=conf.MYSQL_HOST, user=conf.APPDB_USER, passwd=conf.APPDB_PSWD, db=conf.APPDB_NAME, port=conf.MYSQL_PORT )
    mysclient=mysconn.cursor()
except Exception,e:
    print e
    sys.exit(1)
    
for row in rows:

    row = row.split('\t')
    area=row[0]
    cnt=row[1]
    succcnt=row[2]

    try:
        #print "%s %s %s" %(area, cnt, succcnt)
        updateTable( '%s-%s-01' %( year,month ), area, 'ordernum', cnt )
        updateTable( '%s-%s-01' %( year,month ), area, 'successordernum', succcnt )
    except Exception,e:
	print e
	continue
    
mysclient.close()
mysconn.close()

# 司机注册统计 全量表
hql="""
SELECT (CASE WHEN area IS NULL THEN '10000' ELSE area END),
COUNT(*) cnt FROM driver 
WHERE year='%s' AND month='%s' AND day='%s' 
AND year(regtime)='%s' and month(regtime)='%s' 
GROUP BY area GROUPING SETS (area,())
""" %( hp_year, hp_month, hp_day, year, month )
print hql
client.execute( hql )
rows = client.fetchAll()

try:
    mysconn=MySQLdb.connect( host=conf.MYSQL_HOST, user=conf.APPDB_USER, passwd=conf.APPDB_PSWD, db=conf.APPDB_NAME, port=conf.MYSQL_PORT )
    mysclient=mysconn.cursor()
except Exception,e:
    print e
    sys.exit(1)

for row in rows:

    row = row.split('\t')
    area=row[0]
    regcnt=row[1]

    try:
        #print "%s %s" %(area,regcnt)
        updateTable( '%s-%s-01' %( year,month ), area, 'drivernum', regcnt )
    except Exception,e:
	print e
	continue
	
# 乘客注册统计 全量表
hql="""
SELECT (CASE WHEN area IS NULL THEN '10000' ELSE area END),
COUNT(*) cnt FROM passenger 
WHERE year='%s' AND month='%s' AND day='%s' 
AND year(regtime)='%s' and month(regtime)='%s' 
GROUP BY area GROUPING SETS (area,())
""" %( hp_year, hp_month, hp_day, year, month )
print hql
client.execute( hql )
rows = client.fetchAll()

try:
    mysconn=MySQLdb.connect( host=conf.MYSQL_HOST, user=conf.APPDB_USER, passwd=conf.APPDB_PSWD, db=conf.APPDB_NAME, port=conf.MYSQL_PORT )
    mysclient=mysconn.cursor()
except Exception,e:
    print e
    sys.exit(1)

for row in rows:

    row = row.split('\t')
    area=row[0]
    regcnt=row[1]

    try:
        updateTable( '%s-%s-01' %( year,month ), area, 'passengernum', regcnt )
    except Exception,e:
	print e
	continue
	
transport.close()

###################
# main函数模块        
if __name__=='__main__':
    try:
        pass
    except Exception,e:
        print e
