#function description: drivertotalreg
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

#insert recorders from datawarehouse.Driver to data_mart.DriverTotalReg
/home/xiaoju/hive-0.10.0/bin/hive -e  "use app;
    INSERT OVERWRITE TABLE DRIVERTOTALREG PARTITION(YEAR='${LAST_DAY_YEAR}',MONTH='${LAST_DAY_MONTH}',DAY='${LAST_DAY}')
        SELECT 0,'${YESTERDAY}',
				Z.AREA,
				Z.CHANNEL,
				(CASE WHEN A.DRIVERREGNUM IS NULL THEN 0 ELSE CAST(A.DRIVERREGNUM AS INT) END),
				(CASE WHEN B.DRIVERAPPROVEDNUM IS NULL THEN 0 ELSE CAST(B.DRIVERAPPROVEDNUM AS INT) END),
				(CASE WHEN C.DRIVERACTIVEDNUM IS NULL THEN 0 ELSE CAST(C.DRIVERACTIVEDNUM AS INT) END),
				(CASE WHEN D.DRIVERREGNUMFROMBD IS NULL THEN 0 ELSE CAST(D.DRIVERREGNUMFROMBD AS INT) END),
				(CASE WHEN E.DRIVERACTIVEDNUMFROMBD IS NULL THEN 0 ELSE CAST(E.DRIVERACTIVEDNUMFROMBD AS INT) END)
	    FROM 
            PDW.DRIVER_AREA_CHANNEL Z
            LEFT OUTER JOIN
	        (
			SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
		           (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
				   DRIVERREGNUM
	       FROM
		   (
              SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) AS CHANNEL,   
                    COUNT(*) DRIVERREGNUM
              FROM PDW.DRIVER 
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
              AND REGDATE !='' 
	        AND REGDATE < '${TODAY}'
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
	         LEFT OUTER JOIN 
             (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
				    (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					DRIVERAPPROVEDNUM
	         FROM 
			 (
              SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) AS CHANNEL,   
                    COUNT(*) DRIVERAPPROVEDNUM
              FROM PDW.DRIVER
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
              AND CHECKDATE !=''
	        AND CHECKDATE < '${TODAY}'
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
	         LEFT OUTER JOIN 
             (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
		            (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					DRIVERACTIVEDNUM
	         FROM
			 (
              SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) AS CHANNEL,   
                    COUNT(*) DRIVERACTIVEDNUM
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
             ) C
             ON (Z.AREA = C.AREA AND Z.CHANNEL = C.CHANNEL)
	         LEFT OUTER JOIN 
             (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					DRIVERREGNUMFROMBD
	          FROM
		   (
              SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) AS CHANNEL,   
                    COUNT(*) DRIVERREGNUMFROMBD
              FROM PDW.DRIVER 
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
              AND REGDATE IS NOT NULL AND SOURCE > 0 AND REGDATE < '${TODAY}'
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
	         LEFT OUTER JOIN 
             (
			 SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					DRIVERACTIVEDNUMFROMBD
	         FROM
			 (
              SELECT AREA,
                   (CASE 
                    WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
                    ELSE 2
                    END) AS CHANNEL,   
                    COUNT(*) DRIVERACTIVEDNUMFROMBD
              FROM PDW.DRIVER 
              WHERE YEAR='${LAST_DAY_YEAR}'
              AND MONTH='${LAST_DAY_MONTH}'
              AND DAY='${LAST_DAY}'
              AND ACTIVEDATE !='' AND SOURCE > 0 AND ACTIVEDATE < '${TODAY}'
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
             ) E
             ON (Z.AREA = E.AREA AND Z.CHANNEL = E.CHANNEL)
;" 
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/drivertotalreg/$LAST_DAY_YEAR/$LAST_DAY_MONTH/$LAST_DAY/_SUCCESS
