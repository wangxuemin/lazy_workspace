#function description: driveronlineday/driveronlineweek/driveronlinemonth
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

#insert recorders from pdw.Driver/DriverZipper to app.DriverOnlineDay
/home/xiaoju/hive-0.10.0/bin/hive -e  "use app;
    INSERT OVERWRITE TABLE DRIVERONLINEDAY PARTITION(YEAR='${LAST_DAY_YEAR}',MONTH='${LAST_DAY_MONTH}',DAY='${LAST_DAY}')
        SELECT 0,
			   '${YESTERDAY}',
			   Z.AREA,
			   Z.CHANNEL,
			   (CASE WHEN B.BELOW_TEN_MIN_CNT IS NOT NULL AND  A.TOTALACTIVEDRIVER IS NOT NULL AND A.TOTALACTIVEDRIVER<>0
			   THEN ROUND(B.BELOW_TEN_MIN_CNT / CAST(A.TOTALACTIVEDRIVER AS FLOAT), 3)
			         ELSE 0.000 END),
			   (CASE WHEN C.BELOW_ONE_HOUR_CNT IS NOT NULL AND A.TOTALACTIVEDRIVER IS NOT NULL AND A.TOTALACTIVEDRIVER<>0
			   THEN ROUND(C.BELOW_ONE_HOUR_CNT / CAST(A.TOTALACTIVEDRIVER AS FLOAT), 3)
			         ELSE 0.000 END),
			   (CASE WHEN D.BELOW_THREE_HOUR_CNT IS NOT NULL AND A.TOTALACTIVEDRIVER IS NOT NULL AND A.TOTALACTIVEDRIVER<>0
			   THEN ROUND(D.BELOW_THREE_HOUR_CNT / CAST(A.TOTALACTIVEDRIVER AS FLOAT), 3)
				     ELSE 0.000 END)		   
	    FROM PDW.DRIVER_AREA_CHANNEL Z
              LEFT OUTER JOIN(
              SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					 (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					 TOTALACTIVEDRIVER
	          FROM
			  (
			  SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) TOTALACTIVEDRIVER
              FROM PDW.DRIVER 
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
              AND ACTIVEDATE !='' AND ACTIVEDATE < '${TODAY}'
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS ( AREA,
							(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
				) W
             ) A
             ON (Z.AREA = A.AREA AND Z.CHANNEL = A.CHANNEL)
	         LEFT OUTER JOIN (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
		            (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					BELOW_TEN_MIN_CNT
	         FROM
			 (
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) BELOW_TEN_MIN_CNT
              FROM (
                    SELECT DID, AVG(ONLINEMINS) MIN, AREA, CHANNEL 
                    FROM PDW.DRIVERZIPPER 
                    WHERE YEAR='${LAST_DAY_YEAR}'
                    AND MONTH='${LAST_DAY_MONTH}'
                    AND DAY='${LAST_DAY}'
                    AND BEGINDATE >= '${YESTERDAY}' AND ENDDATE <= '${TODAY}'
                    AND ACTIVEDATE  !='' 
                    GROUP BY DID,AREA,CHANNEL
                   ) TEMP_TABLE1
                
              WHERE  MIN > 0 AND MIN <= 10
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS ( AREA,
							(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
				) W
             ) B
             ON (Z.AREA = B.AREA AND Z.CHANNEL = B.CHANNEL)
	         LEFT OUTER JOIN (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					BELOW_ONE_HOUR_CNT
	          FROM
			  (
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) BELOW_ONE_HOUR_CNT
              FROM (
                    SELECT DID, AVG(ONLINEMINS) MIN, AREA, CHANNEL 
                    FROM PDW.DRIVERZIPPER 
                    WHERE YEAR='${LAST_DAY_YEAR}'
                    AND MONTH='${LAST_DAY_MONTH}'
                    AND DAY='${LAST_DAY}'
                    AND BEGINDATE >= '${YESTERDAY}' AND ENDDATE <= '${TODAY}'
                    AND ACTIVEDATE  !='' 
                    GROUP BY DID,AREA,CHANNEL
                   ) TEMP_TABLE2
              WHERE MIN > 0 AND MIN <= 60
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS ( AREA,
							(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
				) W
             ) C
             ON (Z.AREA = C.AREA AND Z.CHANNEL = C.CHANNEL)
	         LEFT OUTER JOIN (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					BELOW_THREE_HOUR_CNT
	          FROM
			  (
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) BELOW_THREE_HOUR_CNT
              FROM (
                    SELECT DID, AVG(ONLINEMINS) MIN, AREA, CHANNEL 
                    FROM PDW.DRIVERZIPPER 
                    WHERE YEAR='${LAST_DAY_YEAR}'
                    AND MONTH='${LAST_DAY_MONTH}'
                    AND DAY='${LAST_DAY}'
                    AND BEGINDATE >= '${YESTERDAY}' AND ENDDATE <= '${TODAY}'
                    AND ACTIVEDATE  !='' 
                    GROUP BY DID,AREA,CHANNEL
                   ) TEMP_TABLE3
                
              WHERE  MIN > 0 AND MIN <= 180
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS ( AREA,
							(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
				) W				
             ) D
             ON (Z.AREA = D.AREA AND Z.CHANNEL = D.CHANNEL)
;" 
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/driveronlineday/$LAST_DAY_YEAR/$LAST_DAY_MONTH/$LAST_DAY/_SUCCESS
#insert recorders from pdw.Driver/DriverZipper to app.DriverOnlineWeek
/home/xiaoju/hive-0.10.0/bin/hive -e  "use app;
    INSERT OVERWRITE TABLE DRIVERONLINEWEEK PARTITION(YEAR='${LAST_DAY_YEAR}',MONTH='${LAST_DAY_MONTH}',DAY='${LAST_DAY}')
		SELECT 0,
			   '${YESTERDAY}',
			   Z.AREA,
			   Z.CHANNEL,
			   (CASE WHEN B.BELOW_TEN_MIN_CNT IS NOT NULL AND  A.TOTALACTIVEDRIVER IS NOT NULL AND A.TOTALACTIVEDRIVER<>0
			   THEN ROUND(B.BELOW_TEN_MIN_CNT / CAST(A.TOTALACTIVEDRIVER AS FLOAT), 3)
			         ELSE 0.00 END),
			   (CASE WHEN C.BELOW_ONE_HOUR_CNT IS NOT NULL AND A.TOTALACTIVEDRIVER IS NOT NULL AND A.TOTALACTIVEDRIVER<>0
			   THEN ROUND(C.BELOW_ONE_HOUR_CNT / CAST(A.TOTALACTIVEDRIVER AS FLOAT), 3)
			         ELSE 0.00 END),
			   (CASE WHEN D.BELOW_THREE_HOUR_CNT IS NOT NULL AND A.TOTALACTIVEDRIVER IS NOT NULL AND A.TOTALACTIVEDRIVER<>0
			   THEN ROUND(D.BELOW_THREE_HOUR_CNT / CAST(A.TOTALACTIVEDRIVER AS FLOAT), 3)
				     ELSE 0.00 END)
	    FROM PDW.DRIVER_AREA_CHANNEL Z
              LEFT OUTER JOIN(
			  			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
								(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
								TOTALACTIVEDRIVER
	          FROM
			  (
              SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) TOTALACTIVEDRIVER
              FROM PDW.DRIVER 
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
              AND ACTIVEDATE  !='' AND ACTIVEDATE < '${TODAY}'
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS ( AREA,
							(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
				) W			
             ) A
             ON (Z.AREA = A.AREA AND Z.CHANNEL = A.CHANNEL)
	         LEFT OUTER JOIN (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					BELOW_TEN_MIN_CNT
	          FROM
			  (
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) BELOW_TEN_MIN_CNT
              FROM (
                    SELECT DID, AVG(ONLINEMINS) MIN, AREA, CHANNEL 
                    FROM PDW.DRIVERZIPPER 
			        WHERE CONCAT(YEAR,MONTH,DAY) >= '${WEEK_FIRST_DAY_STR}'
			        AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
                    AND BEGINDATE >= '${WEEK_FIRST_DAY}' AND ENDDATE <= '${TODAY}'
                    AND ACTIVEDATE  !=''
                    GROUP BY DID,AREA,CHANNEL
                   ) TEMP_TABLE1
                
              WHERE  MIN > 0 AND MIN <= 10
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS ( AREA,
							(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
				) W			
             ) B
             ON (Z.AREA = B.AREA AND Z.CHANNEL = B.CHANNEL)
	         LEFT OUTER JOIN (
			 			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
								(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
								BELOW_ONE_HOUR_CNT
	          FROM
			  (
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) BELOW_ONE_HOUR_CNT
              FROM (
                    SELECT DID, AVG(ONLINEMINS) MIN, AREA, CHANNEL 
                    FROM PDW.DRIVERZIPPER 
			        WHERE CONCAT(YEAR,MONTH,DAY) >= '${WEEK_FIRST_DAY_STR}'
			        AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
                    AND BEGINDATE >= '${WEEK_FIRST_DAY}' AND ENDDATE <= '${TODAY}'
                    AND ACTIVEDATE  !='' 
                    GROUP BY DID,AREA,CHANNEL
                   ) TEMP_TABLE2
              WHERE MIN > 0 AND MIN <= 60
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
							GROUPING SETS ( AREA,
							(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
				) W			
             ) C
             ON (Z.AREA = C.AREA AND Z.CHANNEL = C.CHANNEL)
	         LEFT OUTER JOIN (
		SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
				(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
				BELOW_THREE_HOUR_CNT
	          FROM
			  (
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) BELOW_THREE_HOUR_CNT
              FROM (
                    SELECT DID, AVG(ONLINEMINS) MIN, AREA, CHANNEL 
                    FROM PDW.DRIVERZIPPER 
			        WHERE CONCAT(YEAR,MONTH,DAY) >= '${WEEK_FIRST_DAY_STR}'
			        AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
                    AND BEGINDATE >= '${WEEK_FIRST_DAY}' AND ENDDATE <= '${TODAY}'
                    AND ACTIVEDATE  !='' 
                    GROUP BY DID,AREA,CHANNEL
                   ) TEMP_TABLE3
                
              WHERE  MIN > 0 AND MIN <= 180
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS ( AREA,
							(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
				) W		
             ) D
             ON (Z.AREA = D.AREA AND Z.CHANNEL = D.CHANNEL)
;" 
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/driveronlineweek/$LAST_DAY_YEAR/$LAST_DAY_MONTH/$LAST_DAY/_SUCCESS
#insert recorders from pdw.Driver/DriverZipper to app.DriverOnlineMonth
/home/xiaoju/hive-0.10.0/bin/hive -e  "use app;
    INSERT OVERWRITE TABLE DRIVERONLINEMONTH PARTITION(YEAR='${LAST_DAY_YEAR}',MONTH='${LAST_DAY_MONTH}',DAY='${LAST_DAY}')
		SELECT 0,
			   '${YESTERDAY}',
			   Z.AREA,
			   Z.CHANNEL,
			   (CASE WHEN B.BELOW_TEN_MIN_CNT IS NOT NULL AND  A.TOTALACTIVEDRIVER IS NOT NULL AND A.TOTALACTIVEDRIVER<>0
			   THEN ROUND(B.BELOW_TEN_MIN_CNT / CAST(A.TOTALACTIVEDRIVER AS FLOAT), 3)
			         ELSE 0.00 END),
			   (CASE WHEN C.BELOW_ONE_HOUR_CNT IS NOT NULL AND A.TOTALACTIVEDRIVER IS NOT NULL AND A.TOTALACTIVEDRIVER<>0
			   THEN ROUND(C.BELOW_ONE_HOUR_CNT / CAST(A.TOTALACTIVEDRIVER AS FLOAT), 3)
			         ELSE 0.00 END),
			   (CASE WHEN D.BELOW_THREE_HOUR_CNT IS NOT NULL AND A.TOTALACTIVEDRIVER IS NOT NULL AND A.TOTALACTIVEDRIVER<>0
			   THEN ROUND(D.BELOW_THREE_HOUR_CNT / CAST(A.TOTALACTIVEDRIVER AS FLOAT), 3)
				     ELSE 0.00 END)    
	FROM PDW.DRIVER_AREA_CHANNEL Z
              LEFT OUTER JOIN(
		SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
				(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
				TOTALACTIVEDRIVER
	          FROM
			  (
              SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) TOTALACTIVEDRIVER
              FROM PDW.DRIVER 
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
              AND ACTIVEDATE  !='' AND ACTIVEDATE < '${TODAY}'
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS ( AREA,
							(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
				) W							  
             ) A
             ON (Z.AREA = A.AREA AND Z.CHANNEL = A.CHANNEL)
	         LEFT OUTER JOIN (
		SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
				(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
				BELOW_TEN_MIN_CNT
	          FROM
			  (
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) BELOW_TEN_MIN_CNT
              FROM (
                    SELECT DID, AVG(ONLINEMINS) MIN, AREA, CHANNEL 
                    FROM PDW.DRIVERZIPPER 
			        WHERE CONCAT(YEAR,MONTH,DAY) >= '${MONTH_FIRST_DAY_STR}'
			        AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
                    AND BEGINDATE >= '${MONTH_FIRST_DAY}' AND ENDDATE <= '${TODAY}'
                    AND ACTIVEDATE  !='' 
                    GROUP BY DID,AREA,CHANNEL
                   ) TEMP_TABLE1
                
              WHERE  MIN > 0 AND MIN <= 10
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS ( AREA,
							(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
				) W							  
             ) B
             ON (Z.AREA = B.AREA AND Z.CHANNEL = B.CHANNEL)
	         LEFT OUTER JOIN (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					BELOW_ONE_HOUR_CNT
	          FROM
			  (
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) BELOW_ONE_HOUR_CNT
              FROM (
                    SELECT DID, AVG(ONLINEMINS) MIN, AREA, CHANNEL 
                    FROM PDW.DRIVERZIPPER 
			        WHERE CONCAT(YEAR,MONTH,DAY) >= '${MONTH_FIRST_DAY_STR}'
			        AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
                    AND BEGINDATE >= '${MONTH_FIRST_DAY}' AND ENDDATE <= '${TODAY}'
                    AND ACTIVEDATE  !='' 
                    GROUP BY DID,AREA,CHANNEL
                   ) TEMP_TABLE2
              WHERE MIN > 0 AND MIN <= 60
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS ( AREA,
							(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
				) W							  
             ) C
             ON (Z.AREA = C.AREA AND Z.CHANNEL = C.CHANNEL)
	         LEFT OUTER JOIN (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					BELOW_THREE_HOUR_CNT
	          FROM
			  (
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) BELOW_THREE_HOUR_CNT
              FROM (
                    SELECT DID, AVG(ONLINEMINS) MIN, AREA, CHANNEL 
                    FROM PDW.DRIVERZIPPER 
			        WHERE CONCAT(YEAR,MONTH,DAY) >= '${MONTH_FIRST_DAY_STR}'
			        AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
                    AND BEGINDATE >= '${MONTH_FIRST_DAY}' AND ENDDATE <= '${TODAY}'
                    AND ACTIVEDATE  !='' 
                    GROUP BY DID,AREA,CHANNEL
                   ) TEMP_TABLE3
                
              WHERE  MIN > 0 AND MIN <= 180
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS ( AREA,
							(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
				) W							  
             ) D
             ON (Z.AREA = D.AREA AND Z.CHANNEL = D.CHANNEL)
;" 
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/driveronlinemonth/$LAST_DAY_YEAR/$LAST_DAY_MONTH/$LAST_DAY/_SUCCESS