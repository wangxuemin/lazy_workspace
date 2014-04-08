#!/bin/sh

while [ $# -gt 0 ]; do
  case "$1" in
    -date)
      shift
      _date=$1
      shift
      ;;
    -table)
      shift
      _table=$1
      shift
      ;;
    help)
      echo "Usage: `basename $0` -table {table} -date {date}"
      exit
      ;;
    *)
      break
      ;;
  esac
done

v_currentDate=`date +%Y-%m-%d`
v_paramDate=$_date
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
SQOOP_INSTALL="/home/xiaoju/sqoop-1.4.4.bin__hadoop-0.23"

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

echo "Connection to ${datadb_ip}:${datadb_port}?${app_dbname}&username=${db_username}&password=${db_password}"
mkdir -p log

mysql_exec()
{
#    ssh xiaoju@${datadb_ip} "/home/xiaoju/mysql/bin/mysql -h${datadb_ip} -u${db_username} -p${db_password} -P${datadb_port} ${app_dbname} -e \"$@\""
    /home/xiaoju/mysql-client/bin/mysql -h${datadb_ip} -u${db_username} -p${db_password} -P${datadb_port} ${app_dbname} -e "$@"
}

sqoop_all_table()
{
#    cat etc/sqoop-export-table.conf | while read line; do
    for line in `cat etc/sqoop-export-table.conf`; do
        table=${line%%:*}
        column=${line##*:}

        lowertablename=`echo ${table}|awk '{ print tolower( $1 );}'`
        hdfspath=${hive_app_path}/${lowertablename}/${year}/${month}/${day}
        
        if hadoop fs -test -e ${hdfspath%%/}/_SUCCESS ;then
            sql="DELETE FROM ${table} WHERE statDate='${v_executeDate}';"
            echo $sql
            mysql_exec "$sql"
           ${SQOOP_INSTALL}/bin/sqoop export --connect "jdbc:mysql://${datadb_ip}:${datadb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull" --username ${db_username} --password ${db_password} --table ${table} --columns "${column}" --fields-terminated-by '\001' --export-dir ${hdfspath}
        else
            echo Cannot find ${hdfspath%%/}/_SUCCESS 
        fi
    done
}

sqoop_one_table()
{
    for line in `egrep -i "^$1" etc/sqoop-export-table.conf`; do
        table=${line%%:*}
        column=${line##*:}

        if [ ${#table} != ${#_table} ]; then
           continue
        fi

        lowertablename=`echo ${table}|awk '{ print tolower( $1 );}'`
        hdfspath=${hive_app_path}/${lowertablename}/${year}/${month}/${day}

        if hadoop fs -test -e ${hdfspath%%/}/_SUCCESS ;then
            sql="DELETE FROM ${table} WHERE statDate='${v_executeDate}';"
            echo $sql
            echo $column
            mysql_exec "$sql"
            ${SQOOP_INSTALL}/bin/sqoop export --connect "jdbc:mysql://${datadb_ip}:${datadb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull" --username ${db_username} --password ${db_password} --table ${table} --columns "${column}" --fields-terminated-by '\001' --export-dir ${hdfspath}
        else
            echo Cannot find ${hdfspath%%/}/_SUCCESS 
        fi

    done
}

title="SQOOP export occur Exception"
#carbon=55885293@qq.com
#reciver=55885293@qq.com
carbon=lihan@diditaxi.com.cn
reciver=lihan@diditaxi.com.cn
#reciver=bigdata-p@diditaxi.com.cn

if [ -z ${_table} ];then
    sqoop_all_table > log/sqoop_all_table.${v_executeDate}.log 2>&1
    egrep "Cannot find|Caused.*" log/sqoop_all_table.${v_executeDate}.log > log/${v_executeDate}.failed_sqoop_export.lst

    if [ -s log/${v_executeDate}.failed_sqoop_export.lst ];then
        cat log/${v_executeDate}.failed_sqoop_export.lst | mutt -s "${title}" -c "${carbon}" "${reciver}"
    fi
else
    sqoop_one_table ${_table} #>> log/sqoop_export_${_table}.${v_executeDate}.log 2>&1
fi
