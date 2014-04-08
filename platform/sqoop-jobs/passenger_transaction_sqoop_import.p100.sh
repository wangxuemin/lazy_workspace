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

mkdir -p log/tmp
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
sql_head="SELECT transid,orderid,amount,status,replace(replace(replace(status_remark,'\r',''),'\n',''),'|','') as status_remark,trans_type,replace(replace(replace(trans_sub_type,'\r',''),'\n',''),'|','') as trans_sub_type,currency,DATE_FORMAT(create_time,'%Y-%m-%d %H:%i:%s') AS create_time,DATE_FORMAT(complete_time,'%Y-%m-%d %H:%i:%s') AS complete_time,replace(replace(replace(driver_msisdn,'\r',''),'\n',''),'|','') as driver_msisdn,driverid,passengerid,replace(replace(replace(passenger_openid,'\r',''),'\n',''),'|','') as passenger_openid,replace(replace(replace(passenger_phone,'\r',''),'\n',''),'|','') as passenger_phone,replace(replace(replace(remark,'\r',''),'\n',''),'|','') as remark,area,trade_no FROM "
sql_end=" WHERE create_time between '${v_executeDate} 00:00:00' and '${v_executeDate} 23:59:59'"

hadoop fs -rmr /user/xiaoju/data/bi/mysql/passenger_transaction/${year}/${month}/${day}/*
i=0
sql_total=""

for((di=0;di<100;di++)) do
  dii=`echo ${di}|awk '{ printf("%02s", $1); }'`
  for((ti=0;ti<10;ti++)) do
      tii=`echo ${ti}|awk '{ printf("%02s", $1); }'`
    tablename=passtransdb${dii}_passtranstable${tii}
    if [[ -z ${sql_total} ]]; then
        sql_total="${sql_head}${tablename}${sql_end}"        
    else
        sql_total="${sql_total} UNION ALL ${sql_head}${tablename}${sql_end}"
    fi

        i=`expr $i + 1`
        if [ $i -eq 100 ];then
#        echo ${sql_total}
    /home/xiaoju/sqoop-1.4.4.bin__hadoop-1.0.0/bin/sqoop import -D mapred.job.name="passengerdb${dii}_transtable${tii}_sqoop_import" --connect "jdbc:mysql://${masterdb_ip}:${masterdb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull" --username ${db_username} --password ${db_password} --query "${sql_total} AND \$CONDITIONS" --split-by transid -m 1 --fields-terminated-by '\001' --null-string '' --null-non-string '' --as-textfile --target-dir /user/xiaoju/data/bi/mysql/passenger_transaction/${year}/${month}/${day}/db${dii}/table${tii} >log/tmp/${tablename}.log 2>&1
    hadoop fs -mv /user/xiaoju/data/bi/mysql/passenger_transaction/${year}/${month}/${day}/db${dii}/table${tii}/part-m-00000 /user/xiaoju/data/bi/mysql/passenger_transaction/${year}/${month}/${day}/db${dii}table${tii}.txt
            i=0
            sql_total=""
        fi
       done
done

# 清理缓存
#hadoop fs -rmr /user/xiaoju/data/bi/mysql/passenger_transaction.tmp/
# 成功
hadoop fs -touchz /user/xiaoju/data/bi/mysql/passenger_transaction/${year}/${month}/${day}/_SUCCESS
sleep 1
hadoop fs -touchz /user/xiaoju/data/bi/mysql/passenger_transaction/${year}/${month}/${day}/_SUCCESS
sleep 1
hadoop fs -touchz /user/xiaoju/data/bi/mysql/passenger_transaction/${year}/${month}/${day}/_SUCCESS
