#function description: driverapprovedthreeweeks
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
THREE_WEEK_FIRST_DAY=`date --date="${TODAY}-21 day" +%Y-%m-%d`
THREE_WEEK_FIRST_DAY_STR=`date --date="${TODAY}-21 day" +%Y%m%d`
MONTH_FIRST_DAY=`date --date="${TODAY}-30 day" +%Y-%m-%d`
MONTH_FIRST_DAY_STR=`date --date="${TODAY}-30 day" +%Y%m%d`

#insert recorders from pdw.Driver/DriverZipper to app.DriverApprovedThreeWeeks
/home/xiaoju/hive-0.10.0/bin/hive -e  "use app;
    INSERT OVERWRITE TABLE DRIVERAPPROVEDTHREEWEEKS PARTITION(YEAR='${LAST_DAY_YEAR}',MONTH='${LAST_DAY_MONTH}',DAY='${LAST_DAY}')
        SELECT 0,
			  '${YESTERDAY}',
			  Z.AREA,
			  Z.CHANNEL,
			  (CASE WHEN A.APPROVEDDRIVERCNT IS NULL THEN 0 ELSE CAST(A.APPROVEDDRIVERCNT AS INT) END),
			  (CASE WHEN B.DAYONLINEDRIVERCNT IS NULL THEN 0 ELSE CAST(B.DAYONLINEDRIVERCNT AS INT) END),
			  (CASE WHEN B.DAYONLINEDRIVERCNT IS NOT NULL AND A.APPROVEDDRIVERCNT IS NOT NULL AND A.APPROVEDDRIVERCNT <>0
			  THEN
			  ROUND(B.DAYONLINEDRIVERCNT/CAST(A.APPROVEDDRIVERCNT AS FLOAT),3) ELSE 0.000 END),
              (CASE WHEN C.DRIVERAVGORDERSUCCCNT IS NOT NULL AND D.DRIVERONLINEDAY IS NOT NULL AND D.DRIVERONLINEDAY<>0
			  THEN
			  ROUND(C.DRIVERAVGORDERSUCCCNT/CAST(D.DRIVERONLINEDAY AS FLOAT),3) ELSE 0.000 END), 
			  (CASE WHEN C.DRIVERAVGORDERBROADCASTCNT IS NOT NULL AND D.DRIVERONLINEDAY IS NOT NULL AND D.DRIVERONLINEDAY<>0
			  THEN
			  ROUND(C.DRIVERAVGORDERBROADCASTCNT / CAST(D.DRIVERONLINEDAY AS FLOAT),3) ELSE 0.000 END),
              (CASE WHEN C.DRIVERAVGORDERSTRIVECNT IS NOT NULL AND D.DRIVERONLINEDAY IS NOT NULL AND D.DRIVERONLINEDAY<>0
			  THEN
			  ROUND(C.DRIVERAVGORDERSTRIVECNT/CAST(D.DRIVERONLINEDAY AS FLOAT),3) ELSE 0.000 END),
			  (CASE WHEN E.ORDERSUCCCNTDRIVERCNT IS NULL THEN 0 ELSE CAST(E.ORDERSUCCCNTDRIVERCNT AS INT) END), 
			  (CASE WHEN F.ORDERBREAKCNT IS NOT NULL AND A.APPROVEDDRIVERCNT IS NOT NULL AND A.APPROVEDDRIVERCNT<>0
			  THEN
			  ROUND(F.ORDERBREAKCNT/CAST(A.APPROVEDDRIVERCNT AS FLOAT),3) ELSE 0.000 END),
              (CASE WHEN E.ORDERSUCCCNTDRIVERCNT IS NOT NULL AND A.APPROVEDDRIVERCNT IS NOT NULL AND A.APPROVEDDRIVERCNT<>0
			  THEN
			  ROUND(E.ORDERSUCCCNTDRIVERCNT/CAST(A.APPROVEDDRIVERCNT AS FLOAT), 3) ELSE 0.000 END)
	    FROM PDW.DRIVER_AREA_CHANNEL Z
              LEFT OUTER JOIN(
			  SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					 (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					 APPROVEDDRIVERCNT
				FROM
				(			  
              SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) APPROVEDDRIVERCNT
              FROM PDW.DRIVER 
              WHERE YEAR='${LAST_DAY_YEAR}'
                    AND MONTH='${LAST_DAY_MONTH}'
                    AND DAY='${LAST_DAY}'
                    AND CHECKDATE >= '${THREE_WEEK_FIRST_DAY}' 
                    AND CHECKDATE < '${TODAY}'
              GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS (AREA,
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
					 DAYONLINEDRIVERCNT
			   FROM
			   (			 
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) DAYONLINEDRIVERCNT
             FROM PDW.DRIVERZIPPER 
             WHERE YEAR='${LAST_DAY_YEAR}' AND MONTH='${LAST_DAY_MONTH}' AND DAY='${LAST_DAY}'
                   AND BEGINDATE = '${YESTERDAY}' AND CHECKDATE >= '${THREE_WEEK_FIRST_DAY}' 
                   AND CHECKDATE < '${TODAY}' AND ONLINEMINS > 0
             GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS (AREA,
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
					 DRIVERAVGORDERSUCCCNT,
					 DRIVERAVGORDERBROADCASTCNT,
					 DRIVERAVGORDERSTRIVECNT
				FROM
				(			 
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    SUM(ANSWERORDERCNT) DRIVERAVGORDERSUCCCNT,
                    SUM(BROADCASTORDERCNT) DRIVERAVGORDERBROADCASTCNT,
                    SUM(STRIVEORDERCNT) DRIVERAVGORDERSTRIVECNT
             FROM PDW.DRIVERZIPPER 
			 WHERE CONCAT(YEAR,MONTH,DAY) >= '${THREE_WEEK_FIRST_DAY_STR}'
				   AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
                   AND BEGINDATE >= '${THREE_WEEK_FIRST_DAY}' AND BEGINDATE < '${TODAY}' 
                   AND ACTIVEDATE >= '${THREE_WEEK_FIRST_DAY}' AND ACTIVEDATE < '${TODAY}' 
             GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS (AREA,
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
					 DRIVERONLINEDAY
			   FROM
			   (			 
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(*) DRIVERONLINEDAY
             FROM PDW.DRIVERZIPPER 
			 WHERE CONCAT(YEAR,MONTH,DAY) >= '${THREE_WEEK_FIRST_DAY_STR}'
				   AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
                   AND BEGINDATE >= '${THREE_WEEK_FIRST_DAY}' AND BEGINDATE < '${TODAY}' 
                   AND ACTIVEDATE >= '${THREE_WEEK_FIRST_DAY}' AND ACTIVEDATE < '${TODAY}' AND ONLINEMINS > 0
             GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS (AREA,
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
	         LEFT OUTER JOIN (
			  SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					 (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					 ORDERSUCCCNTDRIVERCNT
			   FROM
			   (			 
             SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) CHANNEL,   
                    COUNT(DISTINCT(DID)) ORDERSUCCCNTDRIVERCNT
             FROM PDW.DRIVERZIPPER 
			 WHERE CONCAT(YEAR,MONTH,DAY) >= '${THREE_WEEK_FIRST_DAY_STR}'
				   AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
                   AND BEGINDATE >= '${THREE_WEEK_FIRST_DAY}' AND BEGINDATE < '${TODAY}' 
                   AND ACTIVEDATE >= '${THREE_WEEK_FIRST_DAY}' AND ACTIVEDATE < '${TODAY}' AND ABOARDORDERCNT > 0
             GROUP BY AREA,
                          ( 
                            CASE
                            WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                            ELSE 2
    	                  	END
                          )
			GROUPING SETS (AREA,
						   (CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
								ELSE 2
							END),
							(AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
									ELSE 2
								END)),
							())
					) W							  
             ) E 
             ON (Z.AREA = E.AREA AND Z.CHANNEL = E.CHANNEL)
	         LEFT OUTER JOIN (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					ORDERBREAKCNT
	          FROM
			  (
             SELECT AREA,
					CHANNEL,
					COUNT(*) ORDERBREAKCNT 
			  FROM  (SELECT AREA,
						  (CASE 
						   WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
						   ELSE 2
						   END) CHANNEL,   
						   MSISDN
					  FROM PDW.DRIVER
					  WHERE YEAR='${LAST_DAY_YEAR}' AND MONTH='${LAST_DAY_MONTH}' AND DAY='${LAST_DAY}'
					    AND ACTIVEDATE >= '${THREE_WEEK_FIRST_DAY}' AND ACTIVEDATE < '${TODAY}'
					 )TEMP1
			   JOIN  (
						SELECT DISTINCT DPHONE 
						FROM PDW.ORDER_COMMENT 
						WHERE CONCAT(YEAR,MONTH,DAY) >= '${THREE_WEEK_FIRST_DAY_STR}'
						AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
						AND CREATETIME >= '${THREE_WEEK_FIRST_DAY}' AND CREATETIME < '${TODAY}' AND DCOMPLAINTTYPE > 0
					 )TEMP2
			    ON (TEMP1.MSISDN = TEMP2.DPHONE)
             GROUP BY AREA,
			          CHANNEL
			 GROUPING SETS (AREA,
			                CHANNEL,
							(AREA,CHANNEL),
							())
			   ) W
             ) F
             ON (Z.AREA = F.AREA AND Z.CHANNEL = F.CHANNEL)
;" 
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/driverapprovedthreeweeks/$LAST_DAY_YEAR/$LAST_DAY_MONTH/$LAST_DAY/_SUCCESS
