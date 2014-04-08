#!/bin/bash
etcfile="./etc/mysql.conf"

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

#sqoop import -D mapred.job.name='driver_sqoop_import' --connect "jdbc:mysql://${masterdb_ip}:${masterdb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false"   --username ${db_username} --password ${db_password} --query "SELECT driverId,sessionKey,msisdn,EXP,friend,PASSWORD,replace(replace(replace(driverName,'\r',''),'\n',''),'|','') as driverName,replace(driverSerial, '|','') as driverSerial,replace(replace(replace(company,'\r',''),'\n',''),'|','') as company,replace(replace(replace(licenseNumber,'\r',''),'\n',''),'|','') as licenseNumber,deviceTocken,deviceID,DATE_FORMAT(regTime,'%Y-%m-%d %H:%i:%s') AS regTime ,regIP,DATE_FORMAT(loginTime,'%Y-%m-%d %H:%i:%s') AS loginTime,loginIP,STATUS,lockTime,unlockTime,lng,lat,DATE_FORMAT(reportTime,'%Y-%m-%d %H:%i:%s') AS reportTime,tmpcnt,channel,AREA,debug,cnt_goodcmt,cnt_badcmt,cnt_order,source,replace(replace(replace(remark,'\r',''),'\n',''),'|','') as remark,remarkid,adminid,DATE_FORMAT(operate,'%Y-%m-%d %H:%i:%s') AS operate,error_rob,today_online,credibility,neatness,punctual,model,warn_num,DATE_FORMAT(auditTime,'%Y-%m-%d %H:%i:%s') AS auditTime,DATE_FORMAT(laststriTime,'%Y-%m-%d %H:%i:%s') AS laststriTime,companyCode,DATE_FORMAT(govAuditTime,'%Y-%m-%d %H:%i:%s') AS govAuditTime FROM Driver WHERE \$CONDITIONS" -m 1 --fields-terminated-by '\001' --null-string '' --null-non-string '' --as-textfile --delete-target-dir --target-dir "/user/leehan/ods"
sqoop import -D mapred.job.name='driver_sqoop_import' --connect "jdbc:mysql://${masterdb_ip}:${masterdb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false"   --username ${db_username} --password ${db_password} --query "SELECT driverId,sessionKey,msisdn,EXP,friend,PASSWORD,replace(replace(replace(driverName,'\r',''),'\n',''),'|','') as driverName,replace(driverSerial, '|','') as driverSerial,replace(replace(replace(company,'\r',''),'\n',''),'|','') as company,replace(replace(replace(licenseNumber,'\r',''),'\n',''),'|','') as licenseNumber,deviceTocken,deviceID,DATE_FORMAT(regTime,'%Y-%m-%d %H:%i:%s') AS regTime ,regIP,DATE_FORMAT(loginTime,'%Y-%m-%d %H:%i:%s') AS loginTime,loginIP,STATUS,lockTime,unlockTime,lng,lat,DATE_FORMAT(reportTime,'%Y-%m-%d %H:%i:%s') AS reportTime,tmpcnt,channel,AREA,debug,cnt_goodcmt,cnt_badcmt,cnt_order,source,replace(replace(replace(remark,'\r',''),'\n',''),'|','') as remark,remarkid,adminid,DATE_FORMAT(operate,'%Y-%m-%d %H:%i:%s') AS operate,error_rob,today_online,credibility,neatness,punctual,model,warn_num,DATE_FORMAT(auditTime,'%Y-%m-%d %H:%i:%s') AS auditTime,DATE_FORMAT(laststriTime,'%Y-%m-%d %H:%i:%s') AS laststriTime,companyCode,DATE_FORMAT(govAuditTime,'%Y-%m-%d %H:%i:%s') AS govAuditTime FROM Driver WHERE \$CONDITIONS" -m 1 --fields-terminated-by '\001' --null-string '' --null-non-string '' --as-textfile --delete-target-dir --target-dir "/user/xiaoju/data/bi/mysql/driver/$v_year/$v_month/$v_day/"
