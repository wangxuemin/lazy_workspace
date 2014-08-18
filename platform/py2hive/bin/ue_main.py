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

if len(sys.argv)>1:
    day=sys.argv[1]
    # 指定日期
    try:
        workday=datetime.datetime.strptime( day, "%Y-%m-%d" )
    except Exception,e:
        print e
        sys.exit(1)
else:
    # 默认昨天
    workday=datetime.date.today()
    oneday=datetime.timedelta(days=1)
    workday=workday-oneday

year  = workday.strftime("%Y")
month = workday.strftime("%m")
day   = workday.strftime("%d")

statDate = "%s-%s-%s" %(year,month,day)
print "logDate is %s" %statDate

###################
# Hive 命令执行函数

def updateDriverTransStrive( statDate, hour, area, oflg, striveorderCnt ):
    
    sql="""
        SELECT * FROM DriverTransAbility WHERE statDate='%s' AND hourseg=%s AND area=%s AND type=%s
        """ %( statDate, hour, area, oflg)
    mysclient.execute( sql )
    rows=mysclient.fetchall()
    
    # 存在 update
    if rows:
        sql="""
        UPDATE DriverTransAbility SET striveorderCnt=%s 
        WHERE statDate='%s' AND hourseg=%s AND area=%s AND type=%s
        """ %(striveorderCnt,statDate, hour, area, oflg)

    # 不存在 insert
    else:
        sql="""
    	INSERT INTO DriverTransAbility ( statDate, hourseg, area, type, striveorderCnt ) 
    	VALUES ( '%s', %s, %s, %s, %s )
    	""" %( statDate, hour, area, oflg, striveorderCnt )
    	
    try:
        mysclient.execute( sql )
        mysconn.commit()
    except Exception,e:
        print e
    
    return
    
def updateDriverTransTask( statDate, hour, area, oflg, taskorderCnt ):
    
    sql="""
        SELECT * FROM DriverTransAbility WHERE statDate='%s' AND hourseg=%s AND area=%s AND type=%s
        """ %( statDate, hour, area, oflg)
        
    mysclient.execute( sql )
    rows=mysclient.fetchall()
    
    # 存在 update
    if rows:
        sql="""
        UPDATE DriverTransAbility SET taskorderCnt=%s 
        WHERE statDate='%s' AND hourseg=%s AND area=%s AND type=%s
        """ %(taskorderCnt,statDate, hour, area, oflg)

    # 不存在 insert
    else:
        sql="""
    	INSERT INTO DriverTransAbility ( statDate, hourseg, area, type, taskorderCnt ) 
    	VALUES ( '%s', %s, %s, %s, %s )
    	""" %( statDate, hour, area, oflg, taskorderCnt )
    	
    try:
        mysclient.execute( sql )
        mysconn.commit()
    except Exception,e:
        print e
    
    return
    
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

# 抢单 统计
hql="""
    SELECT substr(ods_log_nginx.request_time, 12, 2 ) Time,o.area Area,o.type Type,count(*) Cnt 
    FROM ods.ods_log_nginx ods_log_nginx JOIN pdw.dw_order o ON o.orderid = ods_log_nginx.param['orderid'] 
    WHERE ods_log_nginx.year='%s' AND ods_log_nginx.month='%s' AND ods_log_nginx.day='%s' 
    AND o.year='%s' AND o.month='%s' AND o.day='%s' 
    AND ( ods_log_nginx.request_api='/api/v1.1/StriveOrder' or ods_log_nginx.request_api='/api/v2/d_striveorder' )
    GROUP BY substr(ods_log_nginx.request_time, 12, 2 ),o.area,o.type
""" %( year, month, day, year, month, day )

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
    hour=row[0]
    area=row[1]
    oflg=row[2]
    cntt=row[3]

    try:
        updateDriverTransStrive( statDate, hour, area, oflg, cntt )
    except Exception,e:
	print e
	continue
    
mysclient.close()
mysconn.close()

# 听单 统计
hql="""
    SELECT substr(ob.time, 12, 2 ) Time, o.area Area, o.type Type, count(*) Cnt 
    FROM ods.ods_log_broadcastorder ob JOIN pdw.dw_order o ON o.orderid = ob.orderid
    WHERE ob.year='%s' AND ob.month='%s' AND ob.day='%s' 
    AND o.year='%s' AND o.month='%s' AND o.day='%s' 
    GROUP BY substr(ob.time, 12, 2 ), o.area, o.type
"""%( year, month, day, year, month, day )

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
    hour=row[0]
    area=row[1]
    oflg=row[2]
    cntt=row[3]

    try:
        updateDriverTransTask( statDate, hour, area, oflg, cntt )
    except Exception,e:
	print e
	continue
   
mysclient.close()
mysconn.close()

transport.close()

###################
# main函数模块        
if __name__=='__main__':
    try:
        pass
    except Exception,e:
        print e
