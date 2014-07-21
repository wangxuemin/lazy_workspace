#function description: driverorder
#author:changyan

#!/bin/bash
TODAY=$1

if [ -z ${TODAY} ];then
        TODAY=`date +%Y-%m-%d`
fi
#
TODAY_STR=`date --date="${TODAY}" +%Y%m%d`
YESTERDAY=`date --date="${TODAY}-1 day" +%Y-%m-%d`
YESTERDAY_STR=`date --date="${YESTERDAY}" +%Y%m%d`
LAST_DAY=`date --date="${YESTERDAY}" +%d`
LAST_DAY_MONTH=`date --date="${YESTERDAY}" +%m`
LAST_DAY_YEAR=`date --date="${YESTERDAY}" +%Y`
WEEK_FIRST_DAY=`date --date="${TODAY}-7 day" +%Y-%m-%d`
WEEK_FIRST_DAY_STR=`date --date="${TODAY}-7 day" +%Y%m%d`
MONTH_FIRST_DAY=`date --date="${TODAY}-30 day" +%Y-%m-%d`
MONTH_FIRST_DAY_STR=`date --date="${TODAY}-30 day" +%Y%m%d`

#insert recorders from app.OrderDay/DriverDay to app.DriverOrder
/home/xiaoju/hive-0.10.0/bin/hive -e  "use app;
    INSERT OVERWRITE TABLE DRIVERORDER PARTITION(YEAR='${LAST_DAY_YEAR}',MONTH='${LAST_DAY_MONTH}',DAY='${LAST_DAY}')
        SELECT 0,
			   '${YESTERDAY}',
			   Z.AREA,
			   Z.CHANNEL,
			   (CASE WHEN A.ORDERCNT IS NOT NULL AND B.ONLINEDRIVERCNT IS NOT NULL AND B.ONLINEDRIVERCNT <>0
                                                                  THEN ROUND(A.ORDERCNT / CAST(B.ONLINEDRIVERCNT AS FLOAT),3)
			         ELSE 0.000 END),
			   (CASE WHEN A.ORDERSUCCCNT IS NOT NULL AND A.ORDERCNT IS NOT NULL AND A.ORDERCNT<>0
 				  THEN ROUND(A.ORDERSUCCCNT / CAST(A.ORDERCNT AS FLOAT),3)
			         ELSE 0.000 END)	 
	    FROM 
             PDW.DRIVER_AREA_CHANNEL Z
             LEFT OUTER JOIN
             (SELECT AREA,CHANNEL,ORDERCNT,ORDERSUCCCNT
              FROM APP.ORDERDAY
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
             ) A
             ON (Z.AREA = A.AREA AND Z.CHANNEL = A.CHANNEL)
	         LEFT OUTER JOIN (
              SELECT AREA,CHANNEL,ONLINEDRIVERCNT
              FROM APP.DRIVERDAY
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
             ) B
             ON (Z.AREA = B.AREA AND Z.CHANNEL = B.CHANNEL)
;" 
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/driverorder/$LAST_DAY_YEAR/$LAST_DAY_MONTH/$LAST_DAY/_SUCCESS
