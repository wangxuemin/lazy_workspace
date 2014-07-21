#function description: 
#procedure name: P_DM_ordercall
#creator:MARS
#created:
#!/bin/bash
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
# area          	               INT      ,
# channel       	               INT      ,
# orderCallCnt  	               INT      ,
# orderRecallCnt	               INT      ,
# recallOrderCnt	               INT
# )
/home/xiaoju/hive-0.10.0/bin/hive -e"use app;
INSERT OVERWRITE TABLE ORDERCALL  PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0,
	   '$V_YESTERDAY',
	   M.AREA,
	   M.CHANNEL,
	   (CASE WHEN A.ORDERCALLCNT IS NULL THEN 0 ELSE CAST(A.ORDERCALLCNT AS INT) END),
	   (CASE WHEN A.ORDERRECALLCNT IS NULL THEN 0 ELSE CAST(A.ORDERRECALLCNT AS INT) END),
	   (CASE WHEN A.RECALLORDERCNT IS NULL THEN 0 ELSE CAST(A.RECALLORDERCNT AS INT) END)
  FROM PDW.PASSENGER_AREA_CHANNEL M
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
	   ORDERCALLCNT,
	   ORDERRECALLCNT,
	   RECALLORDERCNT
  FROM (SELECT AREA, 
			  (CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
					WHEN CHANNEL >= 101 AND CHANNEL <= 111 THEN 1 
					WHEN CHANNEL >= 150 AND CHANNEL <= 151 THEN 3
					WHEN CHANNEL = 1101 THEN 5
					WHEN CHANNEL = 1102 THEN 6
					WHEN CHANNEL >= 10000 THEN 8
					WHEN CHANNEL >= 1000 THEN 7
					ELSE 2 
				END) AS CHANNEL,
			   SUM(CALLCOUNT) AS ORDERCALLCNT,
			   SUM(CALLCOUNT - 1) AS  ORDERRECALLCNT,
			   SUM(CASE WHEN CALLCOUNT > 1 THEN 1
					 ELSE 0
					END) RECALLORDERCNT
		  FROM PDW.DW_ORDER 
		 WHERE YEAR='$V_PARYEAR'
		   AND MONTH='$V_PARMONTH'
		   AND DAY='$V_PARDAY'
		   AND CREATETIME >= '$V_YESTERDAY' 
		   AND CREATETIME < '$V_TODAY'
                    AND AREA IS NOT NULL
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
		GROUPING SETS (AREA,
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
ON (M.AREA=A.AREA AND M.CHANNEL=A.CHANNEL)
;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/ordercall/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS