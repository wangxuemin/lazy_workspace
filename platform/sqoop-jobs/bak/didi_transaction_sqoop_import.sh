#!/bin/bash
etcfile="./etc/mysql_transaction.conf"

masterdb_ip=`egrep mysql_masterdb_ip ${etcfile}`
masterdb_ip=`echo ${masterdb_ip##*=}|tr -d " "`

masterdb_port=`egrep mysql_masterdb_port ${etcfile}`
masterdb_port=`echo ${masterdb_port##*=}|tr -d " "`

app_dbname=`egrep app_dbname ${etcfile}`
app_dbname=`echo ${app_dbname##*=}|tr -d " "`

db_username=`egrep db_username ${etcfile}`
db_username=`echo ${db_username##*=}|tr -d " "`

db_password=`egrep db_password ${etcfile}`
db_password=`echo ${db_password##*=}|tr -d " "`

if [ -z ${masterdb_ip} ];then
    masterdb_ip="hdp998.jx"
fi

if [ -z ${masterdb_port} ];then
    masterdb_port="3366"
fi

if [ -z ${app_dbname} ];then
    app_dbname="app_dididache"
fi

if [ -z ${db_username} ];then
    db_username="app_r"
fi

if [ -z ${db_password} ];then
    db_password="app_r"
fi

echo "Connection to ${masterdb_ip}:${masterdb_port}?${app_dbname}&username=${db_username}&password=${db_password}"

v_currentDate=`date +%Y-%m-%d`
v_paramDate=$1
v_executeDate=""
if [ -z "$v_paramDate" ];then
	v_executeDate=`date --date="$v_currentDate-1 day" +%Y-%m-%d`
#	 echo v_executeDate:"$v_executeDate"
else
	flag=`echo $v_paramDate|grep -e '^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$'`	
	if [ -z "$flag" ];then
		echo "date format is illege! please rewrite!eg:2013-12-12"
		exit 0
	else
		v_executeDate="$v_paramDate"
#		echo v_executeDate:"$v_executeDate"
	fi
fi
echo executeDate:"$v_executeDate"

v_year=`date --date="$v_executeDate" +%Y`
v_month=`date --date="$v_executeDate" +%m`
v_day=`date --date="$v_executeDate" +%d`

#echo "$v_year-$v_month-$v_day"

#sqoop import -D mapred.job.name='didi_transaction_sqoop_import' --connect "jdbc:mysql://${masterdb_ip}:${masterdb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false" --username ${db_username} --password ${db_password} --table didi_transaction --where "create_time between '$v_year-$v_month-$v_day 00:00:00' and  '$v_year-$v_month-$v_day 23:59:59'"  -m 1 --fields-terminated-by '\001'  --null-string ''  --null-non-string '' --as-textfile --delete-target-dir  --target-dir "/user/xiaoju/data/bi/mysql/weixin/didi_transaction/$v_year/$v_month/$v_day/"
sqoop import -D mapred.job.name='didi_transaction_sqoop_import' --connect "jdbc:mysql://${masterdb_ip}:${masterdb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false" --username ${db_username} --password ${db_password} --query "SELECT transid,orderid,prepayid,transaction_id,bank_billno,status,status_remark,trans_type,partner_type,cost,coupon_flag,total_fee,couponid,currency,DATE_FORMAT(create_time,'%Y-%m-%d %H:%i:%s') as create_time,DATE_FORMAT(start_time,'%Y-%m-%d %H:%i:%s') as start_time,DATE_FORMAT(complete_time,'%Y-%m-%d %H:%i:%s') as complete_time,DATE_FORMAT(notify_time,'%Y-%m-%d %H:%i:%s') as notify_time,driverid,driver_name,driver_msisdn,passenger_openid,passengerid,passenger_phone,area,remark,lng,lat,audit_time,tenpay_trans_id FROM didi_transaction where create_time between '${v_executeDate} 00:00:00' and '${v_executeDate} 23:59:59' and \$CONDITIONS " --split-by transid -m 5 --fields-terminated-by '\001'  --null-string ''  --null-non-string '' --as-textfile --delete-target-dir  --target-dir "/user/xiaoju/data/bi/mysql/weixin/didi_transaction/$v_year/$v_month/$v_day/"
