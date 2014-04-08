#!/bin/sh
currday=$1

if [ -z ${currday} ];then
    currday=`date +%Y-%m-%d -d "-1days"`
else
    currday=`date +%Y-%m-%d -d "$currday"` 
    if [ $? != 0 ];then
#echo "Error Date Format..."
        exit
    fi
fi

egrep "Exported|Beginning export" sqoop_all_table.${currday}.log | while read line1;do
    read line2

    table=$line1
    infos=$line2

    output1=`echo $table | awk --re-interval '{
        r="([0-9]{2}/[0-9]{2}/[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}).*Beginning export of ([0-9a-zA-Z_]+).*";
        match( $0, r, rest );
        print rest[1],rest[2];

    }'`

    output2=`echo $infos | awk --re-interval '{
        r="([0-9]{2}/[0-9]{2}/[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}).*Exported ([0-9]+) records.*";
        match( $0, r, rest );
        print rest[1],rest[2];

    }'`

    echo "${output1% *},${output2% *},${output2##* },${output1##* }"| awk -F "," '{
        printf("startTime:[%s] endTime:[%s] %10s %-48s\n",$1,$2,$3,$4);
    }'
#echo $output1 , $output2
done
