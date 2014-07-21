#function description: 
#procedure name: P_DM_driverbdregthreeweek
#creator:MARS
#created:
#!/bin/bash
#today date
V_DATE=$1

if [ -z ${V_DATE} ];then
        V_DATE=`date +%Y-%m-%d`
fi
V_TODAY=`date -d $V_DATE "+%Y-%m-%d"`
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
#30 days ago, 2 days ago data partition 
V_PAR7DAYS=`date --date="$V_DATE-7 day" +%Y%m%d`
V_PAR15DAYS=`date --date="$V_DATE-15 day" +%Y%m%d`
V_PAR30DAYS=`date --date="$V_DATE-30 day" +%Y%m%d`
# (STATID                  INT,STATDATE          STRING,
# area                   	                    INT         ,
# channel                	                    INT         ,
# driverCnt              	                    INT         ,
# dayOnlineDriverCnt     	                    INT         ,
# dayOnlineDriverRate    	                    FLOAT       ,
# weekOnlineDriverCnt    	                    INT         ,
# weekOnlineDriverRate   	                    FLOAT       ,
# weekNotOnlineDriverCnt 	                    INT         ,
# weekNotOnlineDriverRate	                    FLOAT
# )
# $this->subD($this->getTemplateWithValue(1, $this->templateArrayD), $table["weekOnlineDriverRate"]); 
/home/xiaoju/hive-0.10.0/bin/hive -e "use app;
INSERT OVERWRITE TABLE DRIVERBDREGTHREEWEEK PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0,
	   '$V_YESTERDAY',
	   M.AREA,
	   M.CHANNEL,
	   (CASE WHEN A.DRIVERCNT IS NULL THEN 0 ELSE CAST(A.DRIVERCNT AS INT) END),
	   (CASE WHEN B.DAYONLINEDRIVERCNT IS NULL THEN 0 ELSE CAST(B.DAYONLINEDRIVERCNT AS INT) END),
	   (CASE WHEN B.DAYONLINEDRIVERCNT IS NOT NULL AND A.DRIVERCNT IS NOT NULL AND A.DRIVERCNT<>0
		THEN ROUND(B.DAYONLINEDRIVERCNT/A.DRIVERCNT,3) ELSE 0.000 END) DAYONLINEDRIVERRATE,
	   (CASE WHEN C.WEEKONLINEDRIVERCNT IS NULL THEN 0 ELSE CAST(C.WEEKONLINEDRIVERCNT AS INT) END),
	   (CASE WHEN C.WEEKONLINEDRIVERCNT IS NOT NULL AND A.DRIVERCNT IS NOT NULL AND A.DRIVERCNT<>0
               THEN ROUND(C.WEEKONLINEDRIVERCNT/A.DRIVERCNT,3)  
		ELSE 0.000 END) WEEKONLINEDRIVERRATE,
	   (CASE WHEN A.DRIVERCNT IS NOT NULL AND C.WEEKONLINEDRIVERCNT IS NOT NULL THEN A.DRIVERCNT - C.WEEKONLINEDRIVERCNT 
	         WHEN A.DRIVERCNT IS NOT NULL AND C.WEEKONLINEDRIVERCNT IS NULL THEN A.DRIVERCNT 
			 WHEN A.DRIVERCNT IS NULL AND C.WEEKONLINEDRIVERCNT IS NOT NULL THEN 0-C.WEEKONLINEDRIVERCNT
			 ELSE CAST(0 AS BIGINT) END) WEEKNOTONLINEDRIVERCNT,
	   (CASE WHEN C.WEEKONLINEDRIVERCNT IS NOT NULL AND A.DRIVERCNT IS NOT NULL AND A.DRIVERCNT<>0
                 THEN 1- ROUND(C.WEEKONLINEDRIVERCNT/A.DRIVERCNT,3) 
	         ELSE 1.000 END) WEEKNOTONLINEDRIVERRATE
  FROM PDW.DRIVER_AREA_CHANNEL M
 LEFT OUTER JOIN 
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
	   DRIVERCNT
 FROM  (SELECT AREA, 
			  (CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
					ELSE 2
				END)  CHANNEL,
			   COUNT(*)  DRIVERCNT 
		 FROM PDW.DRIVER 
		WHERE YEAR='$V_PARYEAR'
		  AND MONTH='$V_PARMONTH'
		  AND DAY='$V_PARDAY'
		  AND REGDATE >= '$V_THREEWEEKS' 
		  AND REGDATE < '$V_TODAY' 
		  AND SOURCE > 0
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
ON (M.AREA=A.AREA AND M.CHANNEL=A.CHANNEL)
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
	   DAYONLINEDRIVERCNT
  FROM (SELECT AREA, 
			  (CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
					ELSE 2
				END)  CHANNEL,
			  COUNT(*)  DAYONLINEDRIVERCNT 
		 FROM PDW.DRIVERZIPPER 
		WHERE YEAR='$V_PARYEAR'
		  AND MONTH='$V_PARMONTH'
		  AND DAY='$V_PARDAY'
		  AND BEGINDATE = '$V_YESTERDAY'
		  AND REGDATE >= '$V_THREEWEEKS'
		  AND REGDATE < '$V_TODAY'
		  AND ONLINEMINS > 0 
		  AND SOURCE > 0
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
) B
ON (M.AREA=B.AREA AND M.CHANNEL=B.CHANNEL)
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
	   WEEKONLINEDRIVERCNT
  FROM (SELECT AREA, 
			  (CASE WHEN CHANNEL >= 202 AND CHANNEL <= 204 THEN 1 
					ELSE 2
					END)  CHANNEL,
			  COUNT(DISTINCT DID) WEEKONLINEDRIVERCNT 
		 FROM PDW.DRIVERZIPPER 
		WHERE CONCAT(YEAR,MONTH,DAY) >= '$V_PAR7DAYS'
		  AND CONCAT(YEAR,MONTH,DAY) <= '$V_PARYESTERDAY'
		  AND BEGINDATE >= '$V_WEEK'
		  AND BEGINDATE < '$V_TODAY'
		  AND REGDATE >= '$V_THREEWEEKS' 
		  AND REGDATE < '$V_TODAY' 
		  AND ONLINEMINS > 0 
		  AND SOURCE > 0
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
) C
ON(M.AREA=C.AREA AND M.CHANNEL=C.CHANNEL)
;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/driverbdregthreeweek/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS