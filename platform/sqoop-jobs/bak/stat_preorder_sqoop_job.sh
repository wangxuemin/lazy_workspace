#!/bin/sh
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
    # 获取当前 小时 
    # 如果是 1点前的 crontab任务 则加入到昨天分区;如果是白天手动追加 则进入当日分区
    now_hour=`date +%H`
    if [ ${now_hour} -lt 1 ];then

        v_executeDate=`date --date="$v_currentDate-1 day" +%Y-%m-%d`
    else
        v_executeDate=`date +%Y-%m-%d`
    fi
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

sqoop job --exec stat_preorder_sqoop_job -- --connect "jdbc:mysql://${masterdb_ip}:${masterdb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull" --username ${db_username} --password ${db_password} --target-dir /user/xiaoju/data/bi/mysql/stat_preorder/${year}/${month}/${day} >> log/stat_preorder_sqoop_import.log 2>&1
