#!/bin/bash
etcfile="./etc/mysql.conf.red_coupon"

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
else
	flag=`echo $v_paramDate|grep -e '^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$'`	
	if [ -z "$flag" ];then
		echo "date format is illege! please rewrite!eg:2013-12-12"
		exit 0
	else
		v_executeDate="$v_paramDate"
	fi
fi
echo executeDate:"$v_executeDate"

year=`date --date="$v_executeDate" +%Y`
month=`date --date="$v_executeDate" +%m`
day=`date --date="$v_executeDate" +%d`

# add %Y-%m-%d %H:%i:%s
# replace(replace(replace(address,'\r',''),'\n',''),'|','') as address
# DATE_FORMAT(pCommentTime,'%Y-%m-%d %H:%i:%s') AS pCommentTime

sqoop import -D mapred.job.name='r_list_info_sqoop_import' --connect "jdbc:mysql://${masterdb_ip}:${masterdb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull" --username ${db_username} --password ${db_password} --query "SELECT listid,orderid,replace(replace(replace(phone,'\r',''),'\n',''),'|','') as phone,area,DATE_FORMAT(create_time,'%Y-%m-%d %H:%i:%s') AS create_time,DATE_FORMAT(modify_time,'%Y-%m-%d %H:%i:%s') AS modify_time,cnt_items,left_items,replace(replace(replace(openid,'\r',''),'\n',''),'|','') as openid,replace(replace(replace(nickname,'\r',''),'\n',''),'|','') as nickname,replace(replace(replace(head_url,'\r',''),'\n',''),'|','') as head_url,status FROM r_list_info WHERE ( (create_time BETWEEN '${v_executeDate} 00:00:00' AND '${v_executeDate} 23:59:59') or (modify_time BETWEEN '${v_executeDate} 00:00:00' AND '${v_executeDate} 23:59:59') ) and \$CONDITIONS " --delete-target-dir --split-by listid -m 5 --fields-terminated-by '\001' --null-string '' --null-non-string '' --as-textfile --target-dir /user/xiaoju/data/bi/mysql/r_list_info/${year}/${month}/${day}/
