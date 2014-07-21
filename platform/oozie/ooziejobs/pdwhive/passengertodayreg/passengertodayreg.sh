#function description: 
#procedure name: P_DM_passengertodayreg
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
#	(STATID                  INT,STATDATE          STRING,
#	area              	              INT        ,
#	channel           	              INT        ,
#	orderCnt          	              INT        ,
#	orderCallCnt      	              INT        ,
#	orderSuccCnt      	              INT        ,
#	orderSuccRate     	              FLOAT      ,
#	orderNeedCnt      	              INT        ,   not done 
#	orderNeedSuccCnt  	              INT        ,	 not done
#	orderNeedSuccRate 	              FLOAT			 not done	
/home/xiaoju/hive-0.10.0/bin/hive -e "use app;
INSERT OVERWRITE TABLE PASSENGERTODAYREG PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0,
       '$V_YESTERDAY',
	   M.AREA,
	   M.CHANNEL,
	   (CASE WHEN A.ORDERCNT IS NULL THEN 0 ELSE CAST(A.ORDERCNT AS INT) END),
	   (CASE WHEN A.ORDERCALLCNT IS NULL THEN 0 ELSE CAST(A.ORDERCALLCNT AS INT) END),
	   (CASE WHEN A.ORDERSUCCCNT IS NULL THEN 0 ELSE CAST(A.ORDERSUCCCNT AS INT) END),
	   (CASE WHEN A.ORDERSUCCRATE IS NULL THEN 0.000 ELSE A.ORDERSUCCRATE  END),
	   (CASE WHEN A.ORDERNEEDCNT IS NULL THEN 0 ELSE CAST(A.ORDERNEEDCNT AS INT) END),
	   (CASE WHEN A.ORDERNEEDSUCCCNT IS NULL THEN 0 ELSE CAST(A.ORDERNEEDSUCCCNT AS INT) END),
	   (CASE WHEN A.ORDERNEEDSUCCRATE IS NULL THEN 0.000 ELSE A.ORDERNEEDSUCCRATE END)
  FROM PDW.PASSENGER_AREA_CHANNEL M
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       (CASE WHEN CHANNEL IS NULL THEN 0 ELSE CHANNEL END) CHANNEL,
	   ORDERCNT,
	   ORDERCALLCNT,
	   ORDERSUCCCNT,
	   ORDERSUCCRATE,
	   ORDERNEEDCNT,
	   ORDERNEEDSUCCCNT,
	   ORDERNEEDSUCCRATE
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
				SUM(ORDERCNT) ORDERCNT,
				SUM(ORDERCALLCNT) ORDERCALLCNT,
				SUM(SUCCORDERCNT) ORDERSUCCCNT,
				(CASE WHEN SUM(ORDERCNT)<>0 THEN ROUND(SUM(SUCCORDERCNT)/SUM(ORDERCNT),3) 
				      ELSE 0.000 END)ORDERSUCCRATE,
				0  ORDERNEEDCNT,
				0  ORDERNEEDSUCCCNT,
				0.000  ORDERNEEDSUCCRATE
		  FROM PDW.PASSENGERZIPPER 
		 WHERE YEAR='$V_PARYEAR'
		   AND MONTH='$V_PARMONTH'
		   AND DAY='$V_PARDAY'
		   AND BEGINDATE = '$V_YESTERDAY'
		   AND REGTIME >= '$V_YESTERDAY'
		   AND REGTIME < '$V_TODAY'
                    AND AREA IS NOT NULL
		GROUP BY AREA,(CASE WHEN CHANNEL=48 OR CHANNEL=106 OR CHANNEL=1105 THEN 4
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
ON(M.AREA=A.AREA AND M.CHANNEL=A.CHANNEL)
;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/passengertodayreg/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS