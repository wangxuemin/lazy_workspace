#function description: passengercallhistory
#author:changyan

#!/bin/bash
TODAY=$1

if [ -z ${TODAY} ];then
        TODAY=`date +%Y-%m-%d`
fi

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


#insert recorders from datawarehouse.PassengerZipper to data_mart.PassengerCallHistory
/home/xiaoju/hive-0.10.0/bin/hive -e  "use app;
    INSERT OVERWRITE TABLE PASSENGERCALLHISTORY PARTITION(YEAR='${LAST_DAY_YEAR}',MONTH='${LAST_DAY_MONTH}',DAY='${LAST_DAY}')
        SELECT 0,
		       '${YESTERDAY}',
			   Z.AREA, 
			   Z.CHANNEL, 
			   (CASE WHEN A.FIRSTCALLCNT IS NULL THEN 0 ELSE CAST(A.FIRSTCALLCNT AS INT) END),
			   (CASE WHEN B.SECONDCALLCNT IS NULL THEN 0 ELSE CAST(B.SECONDCALLCNT AS INT) END),
			   (CASE WHEN C.THIRDCALLCNT IS NULL THEN 0 ELSE CAST(C.THIRDCALLCNT AS INT) END)
	    FROM 
        PDW.PASSENGER_AREA_CHANNEL Z
        LEFT OUTER JOIN(
		SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
				(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
				FIRSTCALLCNT
	    FROM
		(
		SELECT AREA,
                (   CASE
                    WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
                    WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
                    WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
                    WHEN CHANNEL = 1101 THEN 5
                    WHEN CHANNEL = 1102 THEN 6
                    WHEN CHANNEL >= 10000 THEN 8
                    WHEN CHANNEL >= 1000 THEN 7
                    ELSE 2 
    	        	END
                ) CHANNEL, 
                COUNT(*) FIRSTCALLCNT
           	FROM PDW.PASSENGERZIPPER
            WHERE YEAR='${LAST_DAY_YEAR}'
            AND MONTH='${LAST_DAY_MONTH}'
            AND DAY='${LAST_DAY}'
            AND ENDDATE = '${TODAY}'
            AND ORDERCNT > 0 
            AND TOTALORDERCNT = ORDERCNT
              AND AREA IS NOT NULL
            GROUP BY AREA,
                        (   CASE
                            WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
                            WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
                            WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
                            WHEN CHANNEL = 1101 THEN 5
                            WHEN CHANNEL = 1102 THEN 6
                            WHEN CHANNEL >= 10000 THEN 8
                            WHEN CHANNEL >= 1000 THEN 7
                            ELSE 2 
    	                	END
                        )
			GROUPING SETS ( AREA,
							   (CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
										WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
										WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
										WHEN CHANNEL = 1101 THEN 5
										WHEN CHANNEL = 1102 THEN 6
										WHEN CHANNEL >= 10000 THEN 8
										WHEN CHANNEL >= 1000 THEN 7
										ELSE 2 
										END),
								(AREA,(CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
										WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
										WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
										WHEN CHANNEL = 1101 THEN 5
										WHEN CHANNEL = 1102 THEN 6
										WHEN CHANNEL >= 10000 THEN 8
										WHEN CHANNEL >= 1000 THEN 7
										ELSE 2 
										END)),
								())
			) W
            ) A 
        ON (Z.AREA = A.AREA AND Z.CHANNEL = A.CHANNEL)
	    LEFT OUTER JOIN (
		SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
				(CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
				SECONDCALLCNT
	     FROM
		 (
		SELECT AREA,
                (   CASE
                    WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
                    WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
                    WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
                    WHEN CHANNEL = 1101 THEN 5
                    WHEN CHANNEL = 1102 THEN 6
                    WHEN CHANNEL >= 10000 THEN 8
                    WHEN CHANNEL >= 1000 THEN 7
                    ELSE 2 
    	        	END
                ) CHANNEL, 
                COUNT(*) SECONDCALLCNT
           	FROM PDW.PASSENGERZIPPER
            WHERE YEAR='${LAST_DAY_YEAR}'
            AND MONTH='${LAST_DAY_MONTH}'
            AND DAY='${LAST_DAY}'
            AND ENDDATE = '${TODAY}'
            AND ORDERCNT > 0 
            AND (TOTALORDERCNT - ORDERCNT) < 2
              AND AREA IS NOT NULL
            GROUP BY AREA,
                        (   CASE
                            WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
                            WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
                            WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
                            WHEN CHANNEL = 1101 THEN 5
                            WHEN CHANNEL = 1102 THEN 6
                            WHEN CHANNEL >= 10000 THEN 8
                            WHEN CHANNEL >= 1000 THEN 7
                            ELSE 2 
    	                	END
                        )
			GROUPING SETS ( AREA,
							   (CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
										WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
										WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
										WHEN CHANNEL = 1101 THEN 5
										WHEN CHANNEL = 1102 THEN 6
										WHEN CHANNEL >= 10000 THEN 8
										WHEN CHANNEL >= 1000 THEN 7
										ELSE 2 
										END),
								(AREA,(CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
										WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
										WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
										WHEN CHANNEL = 1101 THEN 5
										WHEN CHANNEL = 1102 THEN 6
										WHEN CHANNEL >= 10000 THEN 8
										WHEN CHANNEL >= 1000 THEN 7
										ELSE 2 
										END)),
								())
				) W
            ) B
        ON (Z.AREA = B.AREA AND Z.CHANNEL = B.CHANNEL)
	    LEFT OUTER JOIN (
				SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
				       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					   THIRDCALLCNT
			  FROM 
		      (
		SELECT AREA,
                (   CASE
                    WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
                    WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
                    WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
                    WHEN CHANNEL = 1101 THEN 5
                    WHEN CHANNEL = 1102 THEN 6
                    WHEN CHANNEL >= 10000 THEN 8
                    WHEN CHANNEL >= 1000 THEN 7
                    ELSE 2 
    	        	END
                ) CHANNEL, 
                COUNT(*) THIRDCALLCNT
           	FROM PDW.PASSENGERZIPPER
            WHERE YEAR='${LAST_DAY_YEAR}'
            AND MONTH='${LAST_DAY_MONTH}'
            AND DAY='${LAST_DAY}'
            AND ENDDATE = '${TODAY}'
            AND ORDERCNT > 0 
            AND (TOTALORDERCNT - ORDERCNT) < 3
	      AND AREA IS NOT NULL
            GROUP BY AREA,
                        (   CASE
                            WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
                            WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
                            WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
                            WHEN CHANNEL = 1101 THEN 5
                            WHEN CHANNEL = 1102 THEN 6
                            WHEN CHANNEL >= 10000 THEN 8
                            WHEN CHANNEL >= 1000 THEN 7
                            ELSE 2 
    	                	END
                        )
			GROUPING SETS ( AREA,
							   (CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
										WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
										WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
										WHEN CHANNEL = 1101 THEN 5
										WHEN CHANNEL = 1102 THEN 6
										WHEN CHANNEL >= 10000 THEN 8
										WHEN CHANNEL >= 1000 THEN 7
										ELSE 2 
										END),
								(AREA,(CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
										WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
										WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
										WHEN CHANNEL = 1101 THEN 5
										WHEN CHANNEL = 1102 THEN 6
										WHEN CHANNEL >= 10000 THEN 8
										WHEN CHANNEL >= 1000 THEN 7
										ELSE 2 
										END)),
								())
				) W
            ) C
        ON (Z.AREA = C.AREA AND Z.CHANNEL = C.CHANNEL)
;" 
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/passengercallhistory/$LAST_DAY_YEAR/$LAST_DAY_MONTH/$LAST_DAY/_SUCCESS
