#!/bin/bash

TODAY=$1
if [ -z ${TODAY} ];then
        TODAY=`date +%Y-%m-%d`
fi
YESTERDAY=`date --date="${TODAY}-1 day" +%Y-%m-%d`
DAY=`date --date="${YESTERDAY}" +%d`
MONTH=`date --date="${YESTERDAY}" +%m`
YEAR=`date --date="${YESTERDAY}" +%Y`
INPUT_DIR="/user/xiaoju/data/bi/mysql/order/${YEAR}/${MONTH}/${DAY}"
OUTPUT_DIR="/user/xiaoju/data/bi/pdw/passenger_need_num/${YEAR}/${MONTH}/${DAY}"
$HADOOP_HOME/bin/hadoop fs -test -e $INPUT_DIR/_SUCCESS
#重试三次
i=0
while [ $? -ne 0 ]
do
    sleep 3600
    let i=i+1
    $HADOOP_HOME/bin/hadoop fs -test -e $INPUT_DIR/_SUCCESS
    if [ $i -gt 3 ]
    then
        echo "$INPUT_DIR/_SUCCESS not existed !"
        exit
    fi
done
$HADOOP_HOME/bin/hadoop fs -test -d $OUTPUT_DIR
if [ $? -eq 0 ]
then
    $HADOOP_HOME/bin/hadoop fs -rmr $OUTPUT_DIR
fi
$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/contrib/streaming/hadoop-streaming-*.jar \
-input $INPUT_DIR \
-output $OUTPUT_DIR \
-mapper passenger_need_mapper.py \
-file passenger_need_mapper.py \
-jobconf mapred.job.name=passenger-need-${YESTERDAY}

exe_hive="/home/xiaoju/hive-0.10.0/bin/hive"
$exe_hive -e "
    use pdw;
    ALTER TABLE passenger_need ADD PARTITION  (year='${YEAR}',month='${MONTH}',day='${DAY}') \
    location '/user/xiaoju/data/bi/pdw/passenger_need_num/${YEAR}/${MONTH}/${DAY}';
"
