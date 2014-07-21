#function description: 
#procedure name: P_DM_area_channel
#creator:MARS
#created:
#!/bin/bash
#today date
V_DATE=$1

if [ -z ${V_DATE} ];then
        V_DATE=`date +%Y-%m-%d`
fi
V_TODAY=`date -d $V_DATE "+%Y-%m-%d"`
#yesterday data partition
V_PARYEAR=`date --date="$V_DATE-1 day" +%Y`
V_PARMONTH=`date --date="$V_DATE-1 day" +%m`
V_PARDAY=`date --date="$V_DATE-1 day" +%d`
V_PARYESTERDAY=`date --date="$V_DATE-1 day" +%Y%m%d`
/home/xiaoju/hive-0.10.0/bin/hive -e "use pdw;
INSERT OVERWRITE TABLE PASSENGER_AREA_CHANNEL
SELECT A.CITYID  AREA, 
       B.CHANNELID  CHANNEL
  FROM (SELECT *
          FROM PDW.CITY
        WHERE YEAR='$V_PARYEAR'
          AND MONTH='$V_PARMONTH'
          AND DAY='$V_PARDAY'
        ) A 
JOIN 
(SELECT *
   FROM PDW.PASSENGERCHANNEL
)  B
;"
/home/xiaoju/hive-0.10.0/bin/hive -e"use pdw;
INSERT OVERWRITE TABLE DRIVER_AREA_CHANNEL
SELECT A.CITYID  AREA, 
       B.CHANNELID  CHANNEL
  FROM (SELECT *
          FROM PDW.CITY
        WHERE YEAR='$V_PARYEAR'
          AND MONTH='$V_PARMONTH'
          AND DAY='$V_PARDAY'
        )  A 
JOIN 
(SELECT *
   FROM PDW.DRIVERCHANNEL
)  B
;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/pdw/driver_area_channel/_SUCCESS
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/pdw/passenger_area_channel/_SUCCESS