#!/bin/sh

while [ $# -gt 0 ]; do
  case "$1" in
    -conf)
      shift
      etcfile=$1
      shift
      ;;
    -db)
      shift
      db=$1
      shift
      ;;
    -table)
      shift
      table=$1
      shift
      ;;
    help)
      echo "Usage: `basename $0` -table {table} -conf {confile} -db {dbname}"
      exit
      ;;
    *)
      break
      ;;
  esac
done

if [ -z $table ];then
    echo "Specify a table"
    exit
fi

if [ -z $etcfile ];then
    etcfile="./etc/mysql.conf"
fi

#etcfile="./etc/mysql_transaction.conf"
#etcfile="./etc/mysql.conf"

masterdb_ip=`egrep mysql_masterdb_ip ${etcfile}`
masterdb_ip=`echo ${masterdb_ip##*=}|tr -d " "`

masterdb_port=`egrep mysql_masterdb_port ${etcfile}`
masterdb_port=`echo ${masterdb_port##*=}|tr -d " "`

app_dbname=`egrep app_dbname ${etcfile}`
app_dbname=`echo ${app_dbname##*=}|tr -d " "`
app_dbname=${db:-$app_dbname}

db_username=`egrep db_username ${etcfile}`
db_username=`echo ${db_username##*=}|tr -d " "`

db_password=`egrep db_password ${etcfile}`
db_password=`echo ${db_password##*=}|tr -d " "`

mysql -h${masterdb_ip} -u${db_username} -p${db_password} -P${masterdb_port} ${app_dbname} -e "SHOW CREATE TABLE \`$table\`\G" | egrep -v "USE|DROP|KEY|ENGINE|^/|^--" |tr -s '\n' | awk 'BEGIN{
    r_table ="CREATE TABLE `([_0-9A-Za-z]*)`";
    r_column="^[ \t]*`([_0-9A-Za-z]*)`[ \t]*([a-zA-Z]*)";
    i=0; 
}{
    if( match( $0, r_table , restable ))
    {
        table=restable[1];
    }else if( match( $0, r_column, rescol ))
    {
        coltxt=rescol[1];
        colist=rescol[1];
        hive_col=rescol[1]" "rescol[2];
        if ( rescol[2] == "varchar" || rescol[2] == "char" )
        {
            coltxt="REPLACE(REPLACE(REPLACE("rescol[1]",\"\\r\",\"\"),\"\\n\",\"\"),\"||\",\"\") AS "rescol[1];
            hive_col=rescol[1]" string";
        }

        if ( rescol[2] == "timestamp" || rescol[2] == "datetime" )
        {
            coltxt="DATE_FORMAT("rescol[1]",\"%Y-%m-%d %H:%i:%s\") AS "rescol[1];
            hive_col=rescol[1]" string";
        }

        if( table_column_map[table] == "" )
        {
            table_column_map[table]=coltxt;
            table_column[table]=colist;
            hive_table[table]=hive_col;
        }else{
            table_column_map[table]=table_column_map[table]",\\\n"coltxt;
            table_column[table]=table_column[table]","colist;
            hive_table[table]=hive_table[table]",\n"hive_col;
        }
        i+=1;
    }
}END{
    for ( iter in table_column_map )
    {
        print "SELECT \\\n"table_column_map[iter]" \\\nFROM "iter" WHERE \\$CONDITIONS";
        print iter":"table_column[iter];
        print "CREATE EXTERNAL TABLE "iter" (\n"hive_table[iter]")\nPARTITIONED BY ("
        print "year string, month string, day string) "
        print "ROW FORMAT SERDE "
        print "\"org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe\""
        print "STORED AS INPUTFORMAT "
        print "\"org.autonavi.udf.CustomInputFormat\""
        print "OUTPUTFORMAT "
        print "\"org.autonavi.udf.CustomHiveOutputFormat\""
        print i;
    }

}' | sed "s/\"/\'/g" 

