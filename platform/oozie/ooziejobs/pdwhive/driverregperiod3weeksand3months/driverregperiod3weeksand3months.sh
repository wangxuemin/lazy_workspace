#function description: 
#procedure name: P_DM_driverregperiod3weeksand3months
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
# (STATID                  INT,STATDATE          STRING,
# area             	                     INT     ,
# channel          	                     INT     ,
# activeCnt        	                     INT     ,  A
# weekOnlineCnt    	                     INT     ,  B
# weekStriveCnt    	                     INT     ,  B
# weekOrderSuccCnt 	                     INT     ,  B
# weekStayRate     	                     FLOAT   ,  B/A
# weekStriveRate   	                     FLOAT   ,  B/A
# weekOrderSuccRate	                     FLOAT      B/A
# )
# $table["weekStayRate"] = $this->divD($table["weekOnlineCnt"], $table["activeCnt"]);
# $table["weekStriveRate"] = $this->divD($table["weekStriveCnt"], $table["activeCnt"]);
# $table["weekOrderSuccRate"] = $this->divD($table["weekOrderSuccCnt"], $table["activeCnt"]);
# $FROMDATE=$this-> threeMonths
# $TODATE=$this-> threeWeeks
/home/xiaoju/hive-0.10.0/bin/hive -e "use app;
INSERT OVERWRITE TABLE DRIVERREGPERIOD3WEEKSAND3MONTHS PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0,
       '$V_YESTERDAY',
	   M.AREA,
	   M.CHANNEL,
	   (CASE WHEN A.ACTIVECNT IS NULL THEN 0 ELSE CAST(A.ACTIVECNT AS INT) END),
	   (CASE WHEN B.WEEKONLINECNT IS NULL THEN 0 ELSE CAST(B.WEEKONLINECNT AS INT) END),
	   (CASE WHEN B.WEEKSTRIVECNT IS NULL THEN 0 ELSE CAST(B.WEEKSTRIVECNT AS INT) END),
	   (CASE WHEN B.WEEKORDERSUCCCNT IS NULL THEN 0 ELSE CAST(B.WEEKORDERSUCCCNT AS INT) END),
	   (CASE WHEN B.WEEKONLINECNT IS NOT NULL AND A.ACTIVECNT IS NOT NULL THEN ROUND(B.WEEKONLINECNT/CAST(A.ACTIVECNT AS FLOAT),3)  ELSE 0.000 END) weekStayRate,
	   (CASE WHEN B.WEEKSTRIVECNT IS NOT NULL AND A.ACTIVECNT IS NOT NULL THEN ROUND(B.WEEKSTRIVECNT/CAST(A.ACTIVECNT AS FLOAT),3) ELSE 0.000 END) weekStriveRate,
	   (CASE WHEN B.WEEKORDERSUCCCNT IS NOT NULL AND A.ACTIVECNT IS NOT NULL THEN ROUND(B.WEEKORDERSUCCCNT/CAST(A.ACTIVECNT AS FLOAT),3) ELSE 0.000 END)	 weekOrderSuccRate    
  FROM  PDW.DRIVER_AREA_CHANNEL M
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
	   ACTIVECNT
  FROM (SELECT AREA, 
			  (CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
					ELSE 2
				END) AS CHANNEL,
			  COUNT(*) ACTIVECNT 
		 FROM PDW.DRIVER 
		WHERE YEAR='$V_PARYEAR'
		  AND MONTH='$V_PARMONTH'
		  AND DAY='$V_PARDAY'
		  AND ACTIVEDATE >= '$V_THREEMONTHS'
		  AND ACTIVEDATE < '$V_THREEWEEKS'
		GROUP BY AREA, 
			  (CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
					ELSE 2
				END)
		GROUPING SETS ( AREA,
						(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
							ELSE 2
						END),
					   (AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
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
	   WEEKONLINECNT,
	   WEEKSTRIVECNT,
	   WEEKORDERSUCCCNT
  FROM (SELECT AREA, 
			  (CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
					ELSE 2
				END) AS CHANNEL,
			   SUM(CASE WHEN MIN > 0 THEN 1
					 ELSE 0
					END) WEEKONLINECNT,
			   SUM(CASE WHEN CNT > 0 THEN 1
					 ELSE 0
					END) WEEKSTRIVECNT,
			   SUM(CASE WHEN CNT_1 > 0 THEN 1
					 ELSE 0
					END) WEEKORDERSUCCCNT
		 FROM (SELECT DID, 
					   SUM(ONLINEMINS) AS MIN, 
					   SUM(STRIVEORDERCNT) AS CNT ,
					   SUM(ANSWERORDERCNT) AS CNT_1,
					   AREA, 
					   CHANNEL 
				  FROM PDW.DRIVERZIPPER 
				 WHERE CONCAT(YEAR,MONTH,DAY) >= '$V_PAR7DAYS'
				   AND CONCAT(YEAR,MONTH,DAY) <= '$V_PARYESTERDAY'
				   AND BEGINDATE >= '$V_WEEK' 
				   AND BEGINDATE < '$V_TODAY'
				   AND ACTIVEDATE >= '$V_THREEMONTHS' 
				   AND ACTIVEDATE < '$V_THREEWEEKS'
				GROUP BY DID,
						 AREA,
						 CHANNEL
				)  DZ
		GROUP BY AREA, (CASE 
			WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
			ELSE 2
			END)
		GROUPING SETS ( AREA,
						(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
							ELSE 2
						END),
					   (AREA,(CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
							ELSE 2
						END)),
					   ())
		) D
) B
ON (M.AREA = B.AREA AND M.CHANNEL = B.CHANNEL)
	;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/driverregperiod3weeksand3months/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS