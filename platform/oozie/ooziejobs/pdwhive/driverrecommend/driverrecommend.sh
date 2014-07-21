#function description: recommend
#author:changyan

#!/bin/bash
TODAY=$1

if [ -z ${TODAY} ];then
        TODAY=`date +%Y-%m-%d`
fi
#
YESTERDAY=`date --date="${TODAY}-1 day" +%Y-%m-%d`
LAST_DAY=`date --date="${YESTERDAY}" +%d`
LAST_DAY_MONTH=`date --date="${YESTERDAY}" +%m`
LAST_DAY_YEAR=`date --date="${YESTERDAY}" +%Y`
WEEK_FIRST_DAY=`date --date="${TODAY}-7 day" +%Y-%m-%d`
WEEK_FIRST_DAY_STR=`date --date="${TODAY}-7 day" +%Y%m%d`
MONTH_FIRST_DAY=`date --date="${TODAY}-30 day" +%Y-%m-%d`
MONTH_FIRST_DAY_STR=`date --date="${TODAY}-30 day" +%Y%m%d`

/home/xiaoju/hive-0.10.0/bin/hive -e  "use app;
    ALTER TABLE DRIVERRECOMMEND ADD IF NOT EXISTS PARTITION (YEAR = '${LAST_DAY_YEAR}',MONTH = '${LAST_DAY_MONTH}',DAY = '${LAST_DAY}') 
                                LOCATION '$LAST_DAY_YEAR/$LAST_DAY_MONTH/$LAST_DAY';
    INSERT OVERWRITE TABLE driverrecommend PARTITION(YEAR='${LAST_DAY_YEAR}',MONTH='${LAST_DAY_MONTH}',DAY='${LAST_DAY}')
        SELECT 0,
		       '${YESTERDAY}',
			   Z.AREA,
			   0,
			   (
                CASE WHEN A.recommend_count IS NULL THEN 0 
                ELSE CAST(A.recommend_count AS INT) END
               ),
			   (
                CASE WHEN A.recommend_count IS NOT NULL AND B.reg_count IS NOT NULL 
                THEN ROUND(A.recommend_count / CAST(B.reg_count AS FLOAT), 3)
				ELSE 0.00 END
               ),
			   (
                CASE WHEN A.recommend_count IS NOT NULL AND C.online_count IS NOT NULL 
                THEN ROUND(A.recommend_count / CAST(C.online_count AS FLOAT), 3)
				ELSE 0.00 END
               )
        FROM 
             (
               SELECT CITYID AREA 
		       FROM PDW.CITY
			   WHERE YEAR='${LAST_DAY_YEAR}'
			   AND MONTH='${LAST_DAY_MONTH}'
			   AND DAY='${LAST_DAY}'
			 ) Z
             LEFT OUTER JOIN
	         (
			   SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
			          COUNT(DISTINCT recommend_id) recommend_count 
			   FROM pdw.recommend 
			   WHERE YEAR='${LAST_DAY_YEAR}'
			   AND MONTH='${LAST_DAY_MONTH}'
			   AND DAY='${LAST_DAY}'
			   AND createtime = '${YESTERDAY}'
			   AND type = 1
               GROUP BY AREA
			   GROUPING SETS (AREA,())
             ) A
             ON (Z.AREA = A.AREA)
	         LEFT OUTER JOIN (
			   SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
			          COUNT(DISTINCT driverId) reg_count 
			   FROM pdw.driver 
			   WHERE YEAR='${LAST_DAY_YEAR}'
			   AND MONTH='${LAST_DAY_MONTH}'
			   AND DAY='${LAST_DAY}'
			   AND regTime < '${TODAY}'
			   AND status = 1
               GROUP BY AREA
			   GROUPING SETS (AREA,())
             ) B
             ON (Z.AREA = B.AREA)
	         LEFT OUTER JOIN (
			   SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
			          COUNT(DISTINCT dphone) online_count 
			   FROM pdw.op_staticstic_driver
			   WHERE YEAR='${LAST_DAY_YEAR}'
			   AND MONTH='${LAST_DAY_MONTH}'
			   AND DAY='${LAST_DAY}'
			   AND op_staticstic_driver_date = '${YESTERDAY}'
			   AND onlineTime > 0
               GROUP BY AREA
			   GROUPING SETS (AREA,())
             ) C
             ON (Z.AREA = C.AREA)
;" 
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/driverrecommend/$LAST_DAY_YEAR/$LAST_DAY_MONTH/$LAST_DAY/_SUCCESS
