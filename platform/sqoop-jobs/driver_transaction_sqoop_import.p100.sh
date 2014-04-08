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

day3ago=`date  +%Y-%m-%d -d "$v_executeDate -2days"`
v_year=`date --date="$v_executeDate" +%Y`
v_month=`date --date="$v_executeDate" +%m`
v_day=`date --date="$v_executeDate" +%d`

#echo "$v_year-$v_month-$v_day"
sql_head="SELECT * FROM "
sql_end=" WHERE create_time between '${day3ago} 00:00:00' and '${v_executeDate} 23:59:59'"

hadoop fs -rmr /user/xiaoju/data/bi/mysql/driver_transaction/${year}/${month}/${day}/*
i=0
sql_total=""

for((di=0;di<100;di++)) do
  dii=`echo ${di}|awk '{ printf("%02s", $1); }'`
  for((ti=0;ti<10;ti++)) do
      tii=`echo ${ti}|awk '{ printf("%02s", $1); }'`
    tablename=drivertransdb${dii}_drivertranstable${tii}
    if [[ -z ${sql_total} ]]; then
        sql_total="${sql_head}${tablename}${sql_end}"        
    else
        sql_total="${sql_total} UNION ALL ${sql_head}${tablename}${sql_end}"
    fi

        i=`expr $i + 1`
        if [ $i -eq 100 ];then
#        echo ${sql_total}
    /home/xiaoju/sqoop-1.4.4.bin__hadoop-1.0.0/bin/sqoop import -D mapred.job.name="driverdb${dii}_transtable${tii}_sqoop_import" --connect "jdbc:mysql://${masterdb_ip}:${masterdb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull" --username ${db_username} --password ${db_password} --query "${sql_total} AND \$CONDITIONS" --split-by transid -m 1 --fields-terminated-by '\001' --null-string '' --null-non-string '' --as-textfile --target-dir /user/xiaoju/data/bi/mysql/driver_transaction/${year}/${month}/${day}/db${dii}/table${tii} >log/tmp/${tablename}.log 2>&1
    hadoop fs -mv /user/xiaoju/data/bi/mysql/driver_transaction/${year}/${month}/${day}/db${dii}/table${tii}/part-m-00000 /user/xiaoju/data/bi/mysql/driver_transaction/${year}/${month}/${day}/db${dii}table${tii}.txt
            i=0
            sql_total=""
        fi
       done
done

#sqoop import -D mapred.job.name='driver_transaction_sqoop_import' --connect "jdbc:mysql://${masterdb_ip}:${masterdb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false" --username ${db_username} --password ${db_password} --table driver_transaction  --where " create_time between '$v_year-$v_month-$v_day 00:00:00' and '$v_year-$v_month-$v_day 23:59:59'"  -m 1 --fields-terminated-by '\001'  --null-string ''  --null-non-string '' --as-textfile --delete-target-dir  --target-dir "/user/xiaoju/data/bi/mysql/weixin/driver_transaction/$v_year/$v_month/$v_day/"

# ³É¹¦
while true; do
if hadoop fs -touchz /user/xiaoju/data/bi/mysql/driver_transaction/${year}/${month}/${day}/_SUCCESS; then
    break
fi
sleep 1

done