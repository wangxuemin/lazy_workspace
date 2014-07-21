#function description: 
#procedure name: p_dm_firstcallpassengerreplay
#creator:MARS
#created:
#!/bin/bash
#today date
V_DATE=$1
#
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
/home/xiaoju/hive-0.10.0/bin/hive -e"use app;
INSERT OVERWRITE TABLE FIRSTCALLPASSENGERREPLAY PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT  0,
	    '$V_YESTERDAY',
		M.AREA,
		M.CHANNEL,
		(CASE WHEN A.FIRSTCALLREPLAYCNT IS NOT NULL THEN CAST(A.FIRSTCALLREPLAYCNT AS INT) ELSE 0 END) FIRSTCALLREPLAYCNT
  FROM  PDW.PASSENGER_AREA_CHANNEL M
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CAST(CHANNEL AS INT) END) CHANNEL,
	   FIRSTCALLREPLAYCNT
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
			   COUNT(ORDERID) FIRSTCALLREPLAYCNT 
		  FROM (SELECT PASSENGERID,
					   ORDERID,
					   AREA,
					   CHANNEL
				  FROM PDW.DW_ORDER
				 WHERE YEAR='$V_PARYEAR'
				   AND MONTH='$V_PARMONTH'
				   AND DAY='$V_PARDAY'
				   AND CREATETIME  >='$V_YESTERDAY'
				   AND CREATETIME <'$V_TODAY'
				   AND STATUS >= 1 
				   AND STATUS <= 4 
				   AND DRIVERID >0
				) A
		LEFT OUTER JOIN
			   (SELECT DISTINCT PASSENGERID
				  FROM PDW.DW_ORDER
				 WHERE CONCAT(YEAR,MONTH,DAY) < '$V_PARYESTERDAY'
				   AND CREATETIME <'$V_YESTERDAY'
				) B
		ON (A.PASSENGERID = B.PASSENGERID)
		WHERE B.PASSENGERID IS NULL 
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
	    ) W
) A
ON(M.AREA=A.AREA AND M.CHANNEL=A.CHANNEL)
;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/firstcallpassengerreplay/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS