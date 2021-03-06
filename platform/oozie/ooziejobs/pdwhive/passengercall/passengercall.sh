#function description: 
#procedure name: P_DM_passengercall
#creator:MARS
#created:
#!/bin/bash
#today date
V_DATE=$1

if [ -z ${V_DATE} ];then
        V_DATE=`date +%Y-%m-%d`
fi

#yesterday data partition
V_PARYEAR=`date --date="$V_DATE-1 day" +%Y`
V_PARMONTH=`date --date="$V_DATE-1 day" +%m`
V_PARDAY=`date --date="$V_DATE-1 day" +%d`
V_PARYESTERDAY=`date --date="$V_DATE-1 day" +%Y%m%d`
#today,yesterday,7 day  ago,30 days ago,2 days ago  date
V_TODAY=`date -d $V_DATE "+%Y-%m-%d"`
V_YESTERDAY=`date --date="$V_DATE-1 day" +%Y-%m-%d`
V_7DAYS=`date --date="$V_DATE-7 day" +%Y-%m-%d`
V_WEEK=`date --date="$V_DATE-7 day" +%Y-%m-%d`
V_THREEWEEKS=`date --date="$V_DATE-21 day" +%Y-%m-%d`
V_THREEMONTHS=`date --date="$V_DATE-90 day" +%Y-%m-%d`
V_SIXMONTHS=`date --date="$V_DATE-180 day" +%Y-%m-%d`
V_15DAYS=`date --date="$V_DATE-15 day" +%Y-%m-%d`
V_30DAYS=`date --date="$V_DATE-30 day" +%Y-%m-%d`
V_TWODAYS=`date --date="$V_DATE-2 day" +%Y-%m-%d`
#30 days ago, 2 days ago data partition 
V_PAR7DAYS=`date --date="$V_DATE-7 day" +%Y%m%d`
V_PAR15DAYS=`date --date="$V_DATE-15 day" +%Y%m%d`
V_PAR30DAYS=`date --date="$V_DATE-30 day" +%Y%m%d`
V_PAR2DAYS=`date --date="$V_DATE-2 day" +%Y%m%d`
V_PAR2DAYSYEAR=`date --date="$V_DATE-2 day" +%Y`
V_PAR2DAYSMONTH=`date --date="$V_DATE-2 day" +%m`
V_PAR2DAYSDAY=`date --date="$V_DATE-2 day" +%d`
# (STATID                  INT,STATDATE          STRING,
# area                           	        INT       ,
# channel                        	        INT       ,
# todayRegAndCallTransferRate    	        FLOAT     ,
# todayRegAndCallPassengerCnt    	        INT       ,  1
# notTodayRegAndCallPassengerCnt 	        INT       ,  1
# weekCallPassengerCnt           	        INT       ,   2
# monthCallPassengerCnt          	        INT       ,   2
# todayRegAndCallRate            	        FLOAT     ,   1
# notTodayRegAndCallRate         	        FLOAT     ,   1
# monthRegAndCallRate            	        FLOAT     ,   3/2
# notMonthRegAndCallRate         	        FLOAT		  3/2
# )
# $table["todayRegAndCallTransferRate"] = $this->divP($table["todayRegAndCallPassengerCnt"], $this->databaseP["PassengerReg"]["regCnt"]);
# $table["todayRegAndCallRate"] = $this->divP($table["todayRegAndCallPassengerCnt"], $todayCallPassengerCnt);
# $table["notTodayRegAndCallRate"] = $this->divP($table["notTodayRegAndCallPassengerCnt"], $todayCallPassengerCnt);
#TODAYCALLPASSENGERCNT,TODAYREGANDCALLPASSENGERCNT,NOTTODAYREGANDCALLPASSENGERCNT
/home/xiaoju/hive-0.10.0/bin/hive -e "use app;
INSERT OVERWRITE TABLE PASSENGERCALL PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0,
       '$V_YESTERDAY',
	   M.AREA,
	   M.CHANNEL,
	   (CASE WHEN A.TODAYREGANDCALLPASSENGERCNT IS NOT NULL AND W.REGCNT IS NOT NULL AND W.REGCNT<>0
	        THEN ROUND(A.TODAYREGANDCALLPASSENGERCNT/W.REGCNT,3)  ELSE 0.000
			END) TODAYREGANDCALLTRANSFERRATE,
	   (CASE WHEN A.TODAYREGANDCALLPASSENGERCNT IS NULL THEN 0 ELSE CAST(A.TODAYREGANDCALLPASSENGERCNT AS INT) END),
	   (CASE WHEN A.NOTTODAYREGANDCALLPASSENGERCNT IS NULL THEN 0 ELSE CAST(A.NOTTODAYREGANDCALLPASSENGERCNT AS INT) END),
	   (CASE WHEN B.WEEKCALLPASSENGERCNT IS NULL THEN 0 ELSE CAST(B.WEEKCALLPASSENGERCNT AS INT) END),
	   (CASE WHEN C.MONTHCALLPASSENGERCNT IS NULL THEN 0 ELSE CAST(C.MONTHCALLPASSENGERCNT AS INT) END),
	   (CASE WHEN A.TODAYREGANDCALLRATE IS NULL THEN 0.000 ELSE A.TODAYREGANDCALLRATE END),
	   (CASE WHEN A.NOTTODAYREGANDCALLRATE IS NULL THEN 0.000 ELSE A.NOTTODAYREGANDCALLRATE END),
	   (CASE WHEN D.MONTHREGANDCALLPASSENGERCNT IS NOT NULL AND C.MONTHCALLPASSENGERCNT IS NOT NULL AND C.MONTHCALLPASSENGERCNT<>0
	       THEN ROUND(D.MONTHREGANDCALLPASSENGERCNT/C.MONTHCALLPASSENGERCNT,3) ELSE 0.000
		   END)  MONTHREGANDCALLRATE,
	   (CASE WHEN E.NOTMONTHREGANDCALLPASSENGERCNT IS NOT NULL AND C.MONTHCALLPASSENGERCNT IS NOT NULL AND C.MONTHCALLPASSENGERCNT<>0
             THEN ROUND(E.NOTMONTHREGANDCALLPASSENGERCNT/C.MONTHCALLPASSENGERCNT,3)  ELSE 0.000
		   END) NOTMONTHREGANDCALLRATE
  FROM PDW.PASSENGER_AREA_CHANNEL M
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
	   TODAYREGANDCALLPASSENGERCNT,
	   NOTTODAYREGANDCALLPASSENGERCNT,
	   TODAYREGANDCALLRATE,
	   NOTTODAYREGANDCALLRATE
  FROM (SELECT AREA, 
			  (CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
					WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
					WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
					WHEN CHANNEL = 1101 THEN 5
					WHEN CHANNEL = 1102 THEN 6
					WHEN CHANNEL >= 10000 THEN 8
					WHEN CHANNEL >= 1000 THEN 7
					ELSE 2 
					END) CHANNEL,
			  SUM(CASE WHEN REGTIME >= '$V_YESTERDAY' AND REGTIME < '$V_TODAY'  THEN 1
					ELSE 0
					END) TODAYREGANDCALLPASSENGERCNT,
			  SUM(CASE WHEN REGTIME < '$V_YESTERDAY'  AND TOTALORDERCNT = ORDERCNT THEN 1
					ELSE 0
					END) NOTTODAYREGANDCALLPASSENGERCNT,
			  ROUND(SUM(CASE WHEN REGTIME >= '$V_YESTERDAY' AND REGTIME < '$V_TODAY'  THEN 1
					ELSE 0
					END)/CAST(COUNT(*) AS FLOAT),3)  TODAYREGANDCALLRATE,
			  ROUND(SUM(CASE WHEN REGTIME < '$V_YESTERDAY'  AND TOTALORDERCNT = ORDERCNT THEN 1
					ELSE 0
					END)/CAST(COUNT(*) AS FLOAT),3)  NOTTODAYREGANDCALLRATE
		 FROM PDW.PASSENGERZIPPER 
		WHERE YEAR='$V_PARYEAR'
		  AND MONTH='$V_PARMONTH'
		  AND DAY='$V_PARDAY'
		  AND BEGINDATE = '$V_YESTERDAY' 
		  AND ORDERCNT > 0
                   AND AREA IS NOT NULL
		GROUP BY AREA, (CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
							WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
							WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
							WHEN CHANNEL = 1101 THEN 5
							WHEN CHANNEL = 1102 THEN 6
							WHEN CHANNEL >= 10000 THEN 8
							WHEN CHANNEL >= 1000 THEN 7
							ELSE 2 
							END)
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
ON(M.AREA=A.AREA AND M.CHANNEL=A.CHANNEL)
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
	   WEEKCALLPASSENGERCNT
  FROM (SELECT AREA, 
			  (CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
					WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
					WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
					WHEN CHANNEL = 1101 THEN 5
					WHEN CHANNEL = 1102 THEN 6
					WHEN CHANNEL >= 10000 THEN 8 
					WHEN CHANNEL >= 1000 THEN 7
					ELSE 2 
					END) CHANNEL,  
					COUNT(*) WEEKCALLPASSENGERCNT
		 FROM (SELECT AREA,
		              CHANNEL,
					  PID
		         FROM PDW.PASSENGER 
				WHERE YEAR='$V_PARYEAR'
				  AND MONTH='$V_PARMONTH'
				  AND DAY='$V_PARDAY'
				  AND STATUS = 0  
				  AND REGTIME < '$V_TODAY'
                                   AND AREA IS NOT NULL
				) A				  
		JOIN (SELECT DISTINCT PASSENGERID
				FROM PDW.DW_ORDER
			   WHERE CONCAT(YEAR,MONTH,DAY) >= '$V_PAR7DAYS'
				 AND CONCAT(YEAR,MONTH,DAY) <= '$V_PARYESTERDAY'
				 AND CREATETIME >= '$V_WEEK' 
				 AND CREATETIME < '$V_TODAY'
				 ) B   
		  ON  ( A.PID=B.PASSENGERID)
		GROUP BY AREA,(CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
					WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
					WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
					WHEN CHANNEL = 1101 THEN 5
					WHEN CHANNEL = 1102 THEN 6
					WHEN CHANNEL >= 10000 THEN 8 
					WHEN CHANNEL >= 1000 THEN 7
					ELSE 2 
					END)
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
ON(M.AREA=B.AREA AND M.CHANNEL=B.CHANNEL)
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
	   MONTHCALLPASSENGERCNT
  FROM (SELECT AREA, 
			  (CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
					WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
					WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
					WHEN CHANNEL = 1101 THEN 5
					WHEN CHANNEL = 1102 THEN 6
					WHEN CHANNEL >= 10000 THEN 8 
					WHEN CHANNEL >= 1000 THEN 7
					ELSE 2 
					END) CHANNEL,  
					COUNT(*) MONTHCALLPASSENGERCNT
		 FROM (SELECT AREA,
		              CHANNEL,
					  PID
		         FROM PDW.PASSENGER 
				WHERE YEAR='$V_PARYEAR'
				  AND MONTH='$V_PARMONTH'
				  AND DAY='$V_PARDAY'
				  AND STATUS = 0  
				  AND REGTIME < '$V_TODAY'
                                   AND AREA IS NOT NULL 
				) A
		JOIN (SELECT DISTINCT PASSENGERID
				FROM PDW.DW_ORDER
			   WHERE CONCAT(YEAR,MONTH,DAY) >= '$V_PAR30DAYS'
				 AND CONCAT(YEAR,MONTH,DAY) <= '$V_PARYESTERDAY'
				 AND CREATETIME >= '$V_30DAYS'
				 AND CREATETIME < '$V_TODAY'
				 ) B   
		  ON  (A.PID=B.PASSENGERID)
		GROUP BY AREA,(CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
					WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
					WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
					WHEN CHANNEL = 1101 THEN 5
					WHEN CHANNEL = 1102 THEN 6
					WHEN CHANNEL >= 10000 THEN 8 
					WHEN CHANNEL >= 1000 THEN 7
					ELSE 2 
					END)
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
ON (M.AREA=C.AREA AND M.CHANNEL=C.CHANNEL)
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
	   MONTHREGANDCALLPASSENGERCNT
  FROM (
		SELECT AREA,
			  (CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
					WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
					WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
					WHEN CHANNEL = 1101 THEN 5
					WHEN CHANNEL = 1102 THEN 6
					WHEN CHANNEL >= 10000 THEN 8 
					WHEN CHANNEL >= 1000 THEN 7
					ELSE 2 
				END) CHANNEL, 
			   COUNT(*)  MONTHREGANDCALLPASSENGERCNT 
		 FROM (SELECT AREA,
		              CHANNEL,
					  PID 
				 FROM PDW.PASSENGER 
				   WHERE YEAR='$V_PARYEAR'
					 AND MONTH='$V_PARMONTH'
					 AND DAY='$V_PARDAY'
					 AND STATUS = 0 
					 AND REGTIME >= '$V_30DAYS' 
					 AND REGTIME < '$V_TODAY'
                                          AND AREA IS NOT NULL
				   )  A
		  JOIN (SELECT DISTINCT PASSENGERID 
					FROM PDW.DW_ORDER
				   WHERE CONCAT(YEAR,MONTH,DAY) >= '$V_PAR30DAYS'
					 AND CONCAT(YEAR,MONTH,DAY) <= '$V_PARYESTERDAY'
					 AND CREATETIME >= '$V_30DAYS'
					 AND CREATETIME < '$V_TODAY'
				  ) B
			ON ( A.PID = B.PASSENGERID)
        GROUP BY AREA,
		        (CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
					WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
					WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
					WHEN CHANNEL = 1101 THEN 5
					WHEN CHANNEL = 1102 THEN 6
					WHEN CHANNEL >= 10000 THEN 8 
					WHEN CHANNEL >= 1000 THEN 7
					ELSE 2 
					END)
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
					   ( AREA,(CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
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
ON (M.AREA=D.AREA AND M.CHANNEL=D.CHANNEL)
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
	   NOTMONTHREGANDCALLPASSENGERCNT
  FROM (
		SELECT AREA,
			  (CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
					WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
					WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
					WHEN CHANNEL = 1101 THEN 5
					WHEN CHANNEL = 1102 THEN 6
					WHEN CHANNEL >= 10000 THEN 8 
					WHEN CHANNEL >= 1000 THEN 7
					ELSE 2 
				END) CHANNEL, 
			   COUNT(*)  NOTMONTHREGANDCALLPASSENGERCNT 
		 FROM (SELECT AREA,
		              CHANNEL,
					  PID 
				FROM PDW.PASSENGER 
				   WHERE YEAR='$V_PARYEAR'
					 AND MONTH='$V_PARMONTH'
					 AND DAY='$V_PARDAY'
					 AND REGTIME < '$V_30DAYS' 
                                          AND AREA IS NOT NULL
				)  A
		  JOIN (SELECT DISTINCT PASSENGERID 
					FROM PDW.DW_ORDER
				   WHERE CONCAT(YEAR,MONTH,DAY) >= '$V_PAR30DAYS'
					 AND CONCAT(YEAR,MONTH,DAY) <= '$V_PARYESTERDAY'
					 AND CREATETIME >= '$V_30DAYS' 
					 AND CREATETIME < '$V_TODAY'
				  ) B
			ON ( A.PID = B.PASSENGERID)
        GROUP BY AREA,
		        (CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
					WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
					WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
					WHEN CHANNEL = 1101 THEN 5
					WHEN CHANNEL = 1102 THEN 6
					WHEN CHANNEL >= 10000 THEN 8 
					WHEN CHANNEL >= 1000 THEN 7
					ELSE 2 
					END)
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
					   ( AREA,(CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
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
 ) E
ON (M.AREA=E.AREA AND M.CHANNEL=E.CHANNEL)
LEFT OUTER JOIN
(
SELECT AREA,
       CHANNEL,
	   REGCNT
  FROM APP.PASSENGERREG E
 WHERE E.YEAR='$V_PARYEAR' 
   AND E.MONTH='$V_PARMONTH' 
   AND E.DAY='$V_PARDAY'
) W
ON(M.AREA=W.AREA AND M.CHANNEL=W.CHANNEL);
"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/passengercall/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS