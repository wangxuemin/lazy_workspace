#!/bi/sh

etcfile=${1-"./etc/mysql.conf"}

masterdb_ip=`egrep "mysql_masterdb_ip|mysql_datadb_ip" ${etcfile}`
masterdb_ip=`echo ${masterdb_ip##*=}|tr -d " "`

masterdb_port=`egrep "mysql_datadb_port|mysql_masterdb_port" ${etcfile}`
masterdb_port=`echo ${masterdb_port##*=}|tr -d " "`

app_dbname=`egrep app_dbname ${etcfile}`
app_dbname=`echo ${app_dbname##*=}|tr -d " "`

db_username=`egrep db_username ${etcfile}`
db_username=`echo ${db_username##*=}|tr -d " "`

db_password=`egrep db_password ${etcfile}`
db_password=`echo ${db_password##*=}|tr -d " "`

if [ -z $masterdb_ip ] || [ -z $masterdb_port ] || [ -z $db_username ] || [ -z $db_password ] ; then
    echo "Connection to ${masterdb_ip}:${masterdb_port}?${app_dbname}&username=${db_username}&password=${db_password}"
    exit
fi

mysql -h${masterdb_ip} -P${masterdb_port} -u${db_username} -p${db_password} --default-character-set=utf8 ${app_dbname} 
