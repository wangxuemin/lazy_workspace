#function description: passengercallmonth
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


#insert recorders FROM datawarehouse.Order to data_mart.PassengerCallMonth 
/home/xiaoju/hive-0.10.0/bin/hive -e  "use app;
    INSERT OVERWRITE TABLE PASSENGERCALLMONTH PARTITION(YEAR='${LAST_DAY_YEAR}',MONTH='${LAST_DAY_MONTH}',DAY='${LAST_DAY}')
        SELECT 0,'${YESTERDAY}',Z.AREA, Z.CHANNEL, 
               (CASE 
                    WHEN B.FIRSTCALLCNT IS NULL THEN 0
                    WHEN A.PRE_FIRSTCALLCNT IS NULL THEN CAST(B.FIRSTCALLCNT AS INT)
                    ELSE CAST((B.FIRSTCALLCNT- A.PRE_FIRSTCALLCNT) AS INT)
                END),
               (CASE 
                    WHEN D.SECONDCALLCNT IS NULL THEN 0
                    WHEN C.PRE_SECONDCALLCNT IS NULL THEN CAST(D.SECONDCALLCNT AS INT)
                    ELSE CAST((D.SECONDCALLCNT - C.PRE_SECONDCALLCNT) AS INT)
                END),
               (CASE 
                    WHEN F.THIRDCALLCNT IS NULL THEN 0
                    WHEN E.PRE_THIRDCALLCNT IS NULL THEN CAST(F.THIRDCALLCNT AS INT)
                    ELSE CAST((F.THIRDCALLCNT- E.PRE_THIRDCALLCNT) AS INT)
                END)
        FROM PDW.PASSENGER_AREA_CHANNEL Z
        LEFT OUTER JOIN
                (
				SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					   (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					   PRE_FIRSTCALLCNT
				  FROM
				  (
                SELECT AREA, (CASE 
						WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
						WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
						WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
						WHEN CHANNEL = 1101 THEN 5
						WHEN CHANNEL = 1102 THEN 6
						WHEN CHANNEL >= 10000 THEN 8
						WHEN CHANNEL >= 1000 THEN 7
						ELSE 2 
						END) CHANNEL,
						COUNT(*) PRE_FIRSTCALLCNT
                FROM (SELECT COUNT(*) ORDERCNT, 
							 PASSENGERID
					    FROM PDW.DW_ORDER 
					   WHERE CONCAT(YEAR,MONTH,DAY) >= '${MONTH_FIRST_DAY_STR}'
							  AND CONCAT(YEAR,MONTH,DAY) < '${YESTERDAY_STR}'
							  AND CREATETIME >= '${MONTH_FIRST_DAY}'
							  AND CREATETIME < '${YESTERDAY}'
							  GROUP BY PASSENGERID
						) D
				JOIN  (SELECT PID,
						      AREA,
						      CHANNEL
					     FROM PDW.PASSENGER
						WHERE YEAR='$LAST_DAY_YEAR'
						  AND MONTH='$LAST_DAY_MONTH'
						  AND DAY='$LAST_DAY'
                                                    AND AREA IS NOT NULL
				       ) Q
			    ON (D.ORDERCNT > 0 AND D.PASSENGERID=Q.PID)
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
					) D
                ) A
                ON (Z.AREA = A.AREA AND Z.CHANNEL = A.CHANNEL)
                LEFT OUTER JOIN (
				SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
					   (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
					   FIRSTCALLCNT
				 FROM 
				 (
                SELECT AREA, (CASE 
						WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
						WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
						WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
						WHEN CHANNEL = 1101 THEN 5
						WHEN CHANNEL = 1102 THEN 6
						WHEN CHANNEL >= 10000 THEN 8
						WHEN CHANNEL >= 1000 THEN 7
						ELSE 2 
						END) CHANNEL,
						COUNT(*) FIRSTCALLCNT
                FROM (SELECT COUNT(*) ORDERCNT, 
                             PASSENGERID
                      FROM PDW.DW_ORDER
                      WHERE CONCAT(YEAR,MONTH,DAY) >= '${MONTH_FIRST_DAY_STR}'
                      AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
                      AND CREATETIME >= '${MONTH_FIRST_DAY}'
                      AND CREATETIME < '${TODAY}'
                      GROUP BY PASSENGERID
                     ) D
			    JOIN (SELECT PID,
						      AREA,
						      CHANNEL
					     FROM PDW.PASSENGER
						WHERE YEAR='$LAST_DAY_YEAR'
						  AND MONTH='$LAST_DAY_MONTH'
						  AND DAY='$LAST_DAY'
                                                   AND AREA IS NOT NULL
				       ) Q
				ON (D.ORDERCNT > 0 AND D.PASSENGERID=Q.PID)
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
					) D
            ) B
            ON (Z.AREA = B.AREA AND Z.CHANNEL = B.CHANNEL)
            LEFT OUTER JOIN (
			SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
				   (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
				   PRE_SECONDCALLCNT
			  FROM
			  (
                SELECT AREA, (CASE 
						WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
						WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
						WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
						WHEN CHANNEL = 1101 THEN 5
						WHEN CHANNEL = 1102 THEN 6
						WHEN CHANNEL >= 10000 THEN 8
						WHEN CHANNEL >= 1000 THEN 7
						ELSE 2 
						END) CHANNEL,
						COUNT(*) PRE_SECONDCALLCNT
                FROM (SELECT COUNT(*) AS ORDERCNT, 
                             PASSENGERID 
                      FROM PDW.DW_ORDER
                      WHERE CONCAT(YEAR,MONTH,DAY) >= '${MONTH_FIRST_DAY_STR}'
                      AND CONCAT(YEAR,MONTH,DAY) < '${YESTERDAY_STR}'
                      AND CREATETIME >= '${MONTH_FIRST_DAY}'
                      AND CREATETIME < '${YESTERDAY}'
                      GROUP BY PASSENGERID
                      ) D
				JOIN (SELECT PID,
						      AREA,
						      CHANNEL
					     FROM PDW.PASSENGER
						WHERE YEAR='$LAST_DAY_YEAR'
						  AND MONTH='$LAST_DAY_MONTH'
						  AND DAY='$LAST_DAY'
                                                    AND AREA IS NOT NULL 
				       ) Q
				ON (D.ORDERCNT > 1 AND D.PASSENGERID=Q.PID)
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
				) D
            ) C
            ON (Z.AREA = C.AREA AND Z.CHANNEL = C.CHANNEL)
            LEFT OUTER JOIN (
			SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
				   (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
				   SECONDCALLCNT
			  FROM
			  (
                SELECT AREA, (CASE 
						WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
						WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
						WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
						WHEN CHANNEL = 1101 THEN 5
						WHEN CHANNEL = 1102 THEN 6
						WHEN CHANNEL >= 10000 THEN 8
						WHEN CHANNEL >= 1000 THEN 7
						ELSE 2 
						END) CHANNEL,
						COUNT(*) SECONDCALLCNT
                FROM (SELECT COUNT(*) AS ORDERCNT, 
                             PASSENGERID
                      FROM PDW.DW_ORDER 
                      WHERE CONCAT(YEAR,MONTH,DAY) >= '${MONTH_FIRST_DAY_STR}'
                      AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
                      AND CREATETIME >= '${MONTH_FIRST_DAY}'
                      AND CREATETIME < '${TODAY}'
                      GROUP BY PASSENGERID
                      ) D
				JOIN (SELECT PID,
						      AREA,
						      CHANNEL
					     FROM PDW.PASSENGER
						WHERE YEAR='$LAST_DAY_YEAR'
						  AND MONTH='$LAST_DAY_MONTH'
						  AND DAY='$LAST_DAY'
                                            AND AREA IS NOT NULL
				       ) Q
				ON (D.ORDERCNT > 1 AND D.PASSENGERID=Q.PID)
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
            ) D
            ON (Z.AREA = D.AREA AND Z.CHANNEL = D.CHANNEL)
            LEFT OUTER JOIN (
			SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
				   (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
				   PRE_THIRDCALLCNT
			  FROM 
			  (
                SELECT AREA, (CASE 
						WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
						WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
						WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
						WHEN CHANNEL = 1101 THEN 5
						WHEN CHANNEL = 1102 THEN 6
						WHEN CHANNEL >= 10000 THEN 8
						WHEN CHANNEL >= 1000 THEN 7
						ELSE 2 
						END) CHANNEL,
						COUNT(*) PRE_THIRDCALLCNT
                FROM (SELECT COUNT(*) AS ORDERCNT, 
                             PASSENGERID 
                      FROM PDW.DW_ORDER 
                      WHERE CONCAT(YEAR,MONTH,DAY) >= '${MONTH_FIRST_DAY_STR}'
                      AND CONCAT(YEAR,MONTH,DAY) < '${YESTERDAY_STR}'
                      AND CREATETIME >= '${MONTH_FIRST_DAY}'
                      AND CREATETIME < '${YESTERDAY}'
                      GROUP BY PASSENGERID
                      ) D
				JOIN (SELECT PID,
						      AREA,
						      CHANNEL
					     FROM PDW.PASSENGER
						WHERE YEAR='$LAST_DAY_YEAR'
						  AND MONTH='$LAST_DAY_MONTH'
						  AND DAY='$LAST_DAY'
                                            AND AREA IS NOT NULL				       
				) Q
				ON (D.ORDERCNT > 2 AND D.PASSENGERID=Q.PID)
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
            ) E
            ON (Z.AREA = E.AREA AND Z.CHANNEL = E.CHANNEL)
            LEFT OUTER JOIN (
			SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
				   (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
				   THIRDCALLCNT
			  FROM
			  (
                SELECT AREA, (CASE 
						WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
						WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
						WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
						WHEN CHANNEL = 1101 THEN 5
						WHEN CHANNEL = 1102 THEN 6
						WHEN CHANNEL >= 10000 THEN 8
						WHEN CHANNEL >= 1000 THEN 7
						ELSE 2 
						END) CHANNEL,
						COUNT(*) THIRDCALLCNT
                FROM (SELECT COUNT(*) AS ORDERCNT, 
                             PASSENGERID 
                      FROM PDW.DW_ORDER 
                      WHERE CONCAT(YEAR,MONTH,DAY) >= '${MONTH_FIRST_DAY_STR}'
                      AND CONCAT(YEAR,MONTH,DAY) < '${TODAY_STR}'
                      AND CREATETIME >= '${MONTH_FIRST_DAY}'
                      AND CREATETIME < '${TODAY}'
                      GROUP BY PASSENGERID
                      ) D
				JOIN (SELECT PID,
						      AREA,
						      CHANNEL
					     FROM PDW.PASSENGER
						WHERE YEAR='$LAST_DAY_YEAR'
						  AND MONTH='$LAST_DAY_MONTH'
						  AND DAY='$LAST_DAY'
                                                   AND AREA IS NOT NULL
				       ) Q
				ON (D.ORDERCNT > 2 AND D.PASSENGERID=Q.PID)
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
            ) F
            ON (Z.AREA = F.AREA AND Z.CHANNEL = F.CHANNEL)

;" 
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/passengercallmonth/$LAST_DAY_YEAR/$LAST_DAY_MONTH/$LAST_DAY/_SUCCESS
