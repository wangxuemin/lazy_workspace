#!/bin/bash

etcfile="etc/mysql.conf.gulfstream_pay1"

masterdb_ip=`egrep mysql_masterdb_ip ${etcfile}`
masterdb_ip=`echo ${masterdb_ip##*=}|tr -d " "`

masterdb_port=`egrep mysql_masterdb_port ${etcfile}`
masterdb_port=`echo ${masterdb_port##*=}|tr -d " "`

app_dbname=`egrep app_dbname ${etcfile}`
app_dbname=`echo ${app_dbname##*=}|tr -d " "`
app_dbname="diditrans"

db_username=`egrep db_username ${etcfile}`
db_username=`echo ${db_username##*=}|tr -d " "`

db_password=`egrep db_password ${etcfile}`
db_password=`echo ${db_password##*=}|tr -d " "`

if [ $# -eq 0 ];then
    v_executeDate=`date -d "-1day" +%Y-%m-%d`
else
    echo $1 |grep -e '^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$' >/dev/null 2>&1
    if [ $? -ne 0 ];then
        echo "date format illege! eg:2013-12-12"
        exit 1
    else
        v_executeDate=$1
    fi  
fi

source ../sqoopjobs-env.sh
SQOOP=${SQOOP:-"/data/xiaoju/sqoop-1.4.4_hadoop-0.23/bin/sqoop"}
GULFSTREAM_COMMON_PATH=${GULFSTREAM_COMMON_PATH:-"/user/xiaoju/data/bi/gulfstream/"}
GULFSTREAM_COMPRESS_OPTS=${GULFSTREAM_COMPRESS_OPTS:-"--as-textfile"}
SQOOP_COMMON_OPTS=${SQOOP_COMMON_OPTS:-""}

echo "Connection to ${masterdb_ip}:${masterdb_port}?${app_dbname}&username=${db_username}&password=${db_password}"
echo executeDate:"$v_executeDate"

y=`date -d "$v_executeDate" +%Y`
m=`date -d "$v_executeDate" +%m`
d=`date -d "$v_executeDate" +%d`

TABLE="u_business_account"
QUERY="SELECT \
accountid,\
account_type,\
currency,\
REPLACE(REPLACE(REPLACE(userid,'\r',''),'\n',''),'||','') AS userid,\
user_type,\
REPLACE(REPLACE(REPLACE(user_name,'\r',''),'\n',''),'||','') AS user_name,\
REPLACE(REPLACE(REPLACE(user_phone,'\r',''),'\n',''),'||','') AS user_phone,\
balance,\
freeze_balance,\
status,\
customer_accountid,\
customer_account_type,\
DATE_FORMAT(_create_time,'%Y-%m-%d %H:%i:%s') AS _create_time,\
DATE_FORMAT(_modify_time,'%Y-%m-%d %H:%i:%s') AS _modify_time,\
_status,\
REPLACE(REPLACE(REPLACE(sign,'\r',''),'\n',''),'||','') AS sign,\
REPLACE(REPLACE(REPLACE(remark,'\r',''),'\n',''),'||','') AS remark,\
REPLACE(REPLACE(REPLACE(reserved_a,'\r',''),'\n',''),'||','') AS reserved_a,\
REPLACE(REPLACE(REPLACE(reserved_b,'\r',''),'\n',''),'||','') AS reserved_b,\
reserved_i,\
reserved_j,\
DATE_FORMAT(reserved_t,'%Y-%m-%d %H:%i:%s') AS reserved_t \
FROM u_business_account WHERE \$CONDITIONS"

if [ -z ${TABLE} ]; then
    echo $\{TABLE\} is NULL
    exit 1
fi

$SQOOP import -D mapred.job.name="${v_executeDate}.$(basename $0)" \
    --connect "jdbc:mysql://${masterdb_ip}:${masterdb_port}/${app_dbname}?zeroDateTimeBehavior=convertToNull" \
    --username ${db_username} --password ${db_password} --query "$QUERY" \
    -m 1 --fields-terminated-by '\001' --null-string '' --null-non-string '' \
    --delete-target-dir ${GULFSTREAM_COMPRESS_OPTS} ${SQOOP_COMMON_OPTS} \
    --target-dir "${GULFSTREAM_COMMON_PATH%%/}/${TABLE}/$y/$m/$d/"
