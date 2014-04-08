#!/bin/sh
currday=$1

if [ -z ${currday} ];then
    currday=`date +%Y%m%d`
fi

year=`date +%Y -d "${currday}"`
month=`date +%m -d "${currday}"`
day=`date +%d -d "${currday}"`

year=${year:2,2}
grep "${year}/${month}/${day}.*Map input records" *.log | awk -F ":" '{split($2,res," "); print res[1]"\t"$5"\t\t"$1}'
