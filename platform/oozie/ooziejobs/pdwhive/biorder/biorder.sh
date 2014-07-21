#function description: biorder
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

#insert recorders from pdw.dw_order/OrderBroadcast to app.BIOrder
/home/xiaoju/hive-0.10.0/bin/hive -e  "use app;
    INSERT OVERWRITE TABLE BIORDER PARTITION(YEAR='${LAST_DAY_YEAR}',MONTH='${LAST_DAY_MONTH}',DAY='${LAST_DAY}')
        SELECT 0,
		       '${YESTERDAY}',
			   Z.AREA,
			   0,
			   (CASE WHEN A.AVG_DISTANCE IS NULL THEN 0 ELSE CAST(A.AVG_DISTANCE AS INT) END),
			   (CASE WHEN B.TOTAL_ONLINEMINS IS NOT NULL AND C.TOTAL_ORDERS IS NOT NULL THEN
			      ROUND(B.TOTAL_ONLINEMINS / CAST(C.TOTAL_ORDERS AS FLOAT), 3)
				  ELSE 0.00 END),
			   (CASE WHEN B.TOTAL_ONLINEMINS IS NOT NULL AND D.TOTAL_ACTUAL_ORDERS IS NOT NULL THEN
			     ROUND(B.TOTAL_ONLINEMINS / CAST(D.TOTAL_ACTUAL_ORDERS AS FLOAT), 3)
				  ELSE 0.00 END),
			   (CASE WHEN B.TOTAL_ONLINEMINS IS NOT NULL AND E.TOTAL_ADVANCE_ORDERS IS NOT NULL THEN
			     ROUND(B.TOTAL_ONLINEMINS / CAST(E.TOTAL_ADVANCE_ORDERS AS FLOAT), 3)
				 ELSE 0.00 END)
        FROM (SELECT CITYID AREA 
		        FROM PDW.CITY
			   WHERE YEAR='${LAST_DAY_YEAR}'
			     AND MONTH='${LAST_DAY_MONTH}'
				 AND DAY='${LAST_DAY}'
			  ) Z
             LEFT OUTER JOIN
	         (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
			        AVG_DISTANCE
			   FROM
			   (
			 SELECT AREA,AVG(DISTANCE) AVG_DISTANCE
              FROM PDW.DW_ORDER
              WHERE CONCAT(YEAR,MONTH,DAY) >= '${YESTERDAY_STR}'
              AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
              AND CREATETIME >= '${YESTERDAY}'
              AND CREATETIME < '${TODAY}'
              AND TYPE = 0
              AND DRIVERID != 0
              GROUP BY AREA
			  GROUPING SETS (AREA,
			                 ())
			  ) W
             ) A
             ON (Z.AREA = A.AREA)
	         LEFT OUTER JOIN (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
			        TOTAL_ONLINEMINS
			   FROM
			   (
              SELECT AREA, SUM(ONLINEMINS) TOTAL_ONLINEMINS
              FROM PDW.DRIVERZIPPER
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
              AND BEGINDATE = '${YESTERDAY}'
              GROUP BY AREA
			  GROUPING SETS (AREA,
			                 ())
				) W
             ) B
             ON (Z.AREA = B.AREA)
	         LEFT OUTER JOIN (
			  SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
			        TOTAL_ORDERS
			   FROM
			   (
              SELECT AREA, COUNT(*) TOTAL_ORDERS
              FROM PDW.ORDERBROADCAST
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
              GROUP BY AREA
			  GROUPING SETS (AREA,
			                 ())
			    ) W
             ) C
             ON (Z.AREA = C.AREA)
	         LEFT OUTER JOIN (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
			        TOTAL_ACTUAL_ORDERS
			   FROM
			   (
              SELECT AREA, COUNT(*) TOTAL_ACTUAL_ORDERS
              FROM PDW.ORDERBROADCAST
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
              AND TYPE = 0
              GROUP BY AREA
			  GROUPING SETS (AREA,
			                 ())
				) W
             ) D 
             ON (Z.AREA = D.AREA)
	         LEFT OUTER JOIN (
			  SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
			        TOTAL_ADVANCE_ORDERS
			   FROM
			   (
              SELECT AREA, COUNT(*) TOTAL_ADVANCE_ORDERS
              FROM PDW.ORDERBROADCAST
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
              AND TYPE =1 
              GROUP BY AREA
			  GROUPING SETS (AREA,
			                ())
				) W
             ) E
             ON (Z.AREA = E.AREA)
;" 
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/biorder/$LAST_DAY_YEAR/$LAST_DAY_MONTH/$LAST_DAY/_SUCCESS