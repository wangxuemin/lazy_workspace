#!/bin/bash

etcfile="etc/mysql.conf.gulfstream"

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

TABLE="g_driver"
QUERY="SELECT \
       driver_id,\
       REPLACE(REPLACE(REPLACE(session_key,'\r',''),'\n',''),'||','') AS session_key,\
       company_id,\
       team_id,\
       REPLACE(REPLACE(REPLACE(phone,'\r',''),'\n',''),'||','') AS phone,\
       REPLACE(REPLACE(REPLACE(name,'\r',''),'\n',''),'||','') AS name,\
       REPLACE(REPLACE(REPLACE(contact_name,'\r',''),'\n',''),'||','') AS contact_name,\
       REPLACE(REPLACE(REPLACE(contact_phone,'\r',''),'\n',''),'||','') AS contact_phone,\
       REPLACE(REPLACE(REPLACE(languages,'\r',''),'\n',''),'||','') AS languages,\
       REPLACE(REPLACE(REPLACE(password,'\r',''),'\n',''),'||','') AS password,\
       REPLACE(REPLACE(REPLACE(bank_name,'\r',''),'\n',''),'||','') AS bank_name,\
       REPLACE(REPLACE(REPLACE(bank_card_no,'\r',''),'\n',''),'||','') AS bank_card_no,\
       broker_rate,\
       REPLACE(REPLACE(REPLACE(id_card_no,'\r',''),'\n',''),'||','') AS id_card_no,\
       birthday,\
       REPLACE(REPLACE(REPLACE(sex,'\r',''),'\n',''),'||','') AS sex,\
       area,\
       REPLACE(REPLACE(REPLACE(model,'\r',''),'\n',''),'||','') AS model,\
       type,\
       DATE_FORMAT(last_strive_time,'%Y-%m-%d %H:%i:%s') AS last_strive_time,\
       verify_status,\
       ext_verify_status,\
       channel,\
       REPLACE(REPLACE(REPLACE(device_token,'\r',''),'\n',''),'||','') AS device_token,\
       level,\
       REPLACE(REPLACE(REPLACE(recommend,'\r',''),'\n',''),'||','') AS recommend,\
       REPLACE(REPLACE(REPLACE(reg_ip,'\r',''),'\n',''),'||','') AS reg_ip,\
       DATE_FORMAT(reg_time,'%Y-%m-%d %H:%i:%s') AS reg_time,\
       REPLACE(REPLACE(REPLACE(login_ip,'\r',''),'\n',''),'||','') AS login_ip,\
       DATE_FORMAT(login_time,'%Y-%m-%d %H:%i:%s') AS login_time,\
       open_report,\
       DATE_FORMAT(bind_company_time,'%Y-%m-%d %H:%i:%s') AS bind_company_time,\
       DATE_FORMAT(_create_time,'%Y-%m-%d %H:%i:%s') AS _create_time,\
       DATE_FORMAT(_modify_time,'%Y-%m-%d %H:%i:%s') AS _modify_time,\
       _status \
       FROM g_driver WHERE \$CONDITIONS"

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
