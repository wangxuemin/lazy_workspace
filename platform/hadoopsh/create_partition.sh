#!/bin/sh

#DB=pdw
#TABLE=op_redpacket_user
#HDFS_PATH=/user/xiaoju/data/bi/mysql/op_redpacket_user
#
#begdate='2016-06-30'
#enddate='2016-07-30'

USAGE="Usage: `basename $0` -db {hive_db} -tab|-t {hive_table} -path|-p {hdfs_path} -beg {begdate} -end {enddate}"
while [ $# -gt 0 ]; do
  case "$1" in
    -db)
      shift
      DB=$1
      shift
      ;;
    -tab|-t)
      shift
      TABLE=$1
      shift
      ;;
    -path|-p)
      shift
      HDFS_PATH=$1
      shift
      ;;
    -beg)
      shift
      begdate=$1
      shift
      ;;
    -end)
      shift
      enddate=$1
      shift
      ;;
    help)
        echo ${USAGE}
      exit
      ;;
    *)
      break
      ;;
  esac
done

if [ -z "$DB" -o -z "$TABLE" -o -z "$HDFS_PATH" -o -z "$begdate" -o -z "$enddate" ]; then
	echo "NULL FOUND"
	exit 1
fi

hive_num_per_parallel=${hive_num_per_parallel:-15}
parallel=${parallel:-5}

for(( i=0,j=0,p=0; ; i++,j++ ));do

        if [[ ${day} = ${enddate} ]];then
            break;
        fi

        day=`date +%Y-%m-%d -d "+${i}days ${begdate}"`
	
	y=`date +%Y -d "$day"`
	m=`date +%m -d "$day"`
	d=`date +%d -d "$day"`

    if [ -z "$HQL" ]; then
        HQL="ALTER TABLE ${TABLE} 
            ADD IF NOT EXISTS PARTITION 
            (year='$y',month='$m',day='$d') 
            LOCATION '${HDFS_PATH%%/}/$y/$m/$d/'"
    else
        HQL=$HQL";ALTER TABLE ${TABLE} 
            ADD IF NOT EXISTS PARTITION 
            (year='$y',month='$m',day='$d') 
            LOCATION '${HDFS_PATH%%/}/$y/$m/$d/'"
    fi

	if [ $j -eq $hive_num_per_parallel ];then
        
        if [ $p -eq $parallel ] ; then
            wait
        fi
		
        p=`expr $p + 1`
        hive -e "USE ${DB};$HQL" &
        HQL=""
		j=0
	fi

done

if [ -n "$HQL" ];then
    hive -e "USE ${DB};$HQL"
fi
