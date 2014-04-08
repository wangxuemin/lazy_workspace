#!/bin/sh

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

year=`date --date="$v_executeDate" +%Y`
month=`date --date="$v_executeDate" +%m`
day=`date --date="$v_executeDate" +%d`

etcfile="./etc/mysql.conf"

datadb_ip=`egrep mysql_datadb_ip ${etcfile}`
datadb_ip=`echo ${datadb_ip##*=}|tr -d " "`

datadb_port=`egrep mysql_datadb_port ${etcfile}`
datadb_port=`echo ${datadb_port##*=}|tr -d " "`

app_dbname=`egrep app_dbname ${etcfile}`
app_dbname=`echo ${app_dbname##*=}|tr -d " "`

db_username=`egrep db_username ${etcfile}`
db_username=`echo ${db_username##*=}|tr -d " "`

db_password=`egrep db_password ${etcfile}`
db_password=`echo ${db_password##*=}|tr -d " "`

hive_app_path=/user/xiaoju/data/bi/app/
hive_app_path=${hive_app_path%%/}

if [ -z ${datadb_ip} ];then
    datadb_ip="hdp998.jx"
fi

if [ -z ${datadb_port} ];then
    datadb_port="3377"
fi

if [ -z ${app_dbname} ];then
    app_dbname="data_mart"
fi

if [ -z ${db_username} ];then
    db_username="app_w"
fi

if [ -z ${db_password} ];then
    db_password="app_w"
fi

sqoop_all_table()
{
#    cat etc/sqoop-export-table.conf | while read line; do
    for line in `cat etc/sqoop-export-table.conf`; do
        table=${line%%:*}
        column=${line##*:}

        lowertablename=`echo ${table}|awk '{ print tolower( $1 );}'`
        hdfspath=${hive_app_path}/${lowertablename}/${year}/${month}/${day}
#        /home/xiaoju/sqoop-export/bin/sqoop export --connect "jdbc:mysql://${datadb_ip}:${datadb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull" --username ${db_username} --password ${db_password} --table ${table} --columns "${column}" --fields-terminated-by '\001' --export-dir ${hdfspath}
        if hadoop fs -test -e ${hdfspath%%/}/_SUCCESS ;then
            echo "Find ${hdfspath%%/}/_SUCCESS"
        else
            echo Cannot find ${hdfspath%%/}/_SUCCESS
        fi
    done
}
sqoop_all_table

