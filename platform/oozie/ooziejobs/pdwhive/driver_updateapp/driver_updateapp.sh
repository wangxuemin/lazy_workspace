#function description: 
#procedure name: P_DM_driver_updateapp
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
/home/xiaoju/hive-0.10.0/bin/hive -e"use app;
set hive.optimize.cp=true;
set hive.map.aggr=true;
set hive.groupby.mapaggr.checkinterval = 100000;
set hive.exec.parallel=true;
INSERT OVERWRITE TABLE DRIVER_UPDATEAPP PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0,
       '$V_YESTERDAY',
	   A.AREA,
	   0,
	   A.TODAY_TOTAL,
	   (CASE WHEN B.YESTERDAY_TOTAL IS NOT NULL THEN A.TODAY_TOTAL-B.YESTERDAY_TOTAL
	         ELSE A.TODAY_TOTAL
			 END) TODAY_NEWUPDATE
FROM 
(	   
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
		TODAY_TOTAL
  FROM (SELECT AREA,
			   COUNT(DISTINCT PHONE) TODAY_TOTAL
		  FROM (SELECT PHONE
				  FROM PDW.NEWSTATINFO
				 WHERE YEAR='$V_PARYEAR'
				   AND MONTH='$V_PARMONTH'
				   AND DAY='$V_PARDAY'
				   AND APPVERSION >='2.1'
				)  A
		  JOIN (SELECT AREA,
					   MSISDN
				  FROM PDW.DRIVER
				 WHERE YEAR='$V_PARYEAR'
				   AND MONTH='$V_PARMONTH'
				   AND DAY='$V_PARDAY'
				) B
		 ON(A.PHONE= B.MSISDN)
		GROUP BY AREA
		GROUPING SETS(AREA,())
		) W
) A
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
		YESTERDAY_TOTAL
  FROM (SELECT AREA,
			   COUNT(DISTINCT PHONE) YESTERDAY_TOTAL
		  FROM (SELECT PHONE
				  FROM PDW.NEWSTATINFO
				 WHERE CONCAT(YEAR,MONTH,DAY)='$V_PAR2DAYS'
				   AND APPVERSION >='2.1'
				)  A
		 JOIN (SELECT AREA,
					   MSISDN
				  FROM PDW.DRIVER
				 WHERE CONCAT(YEAR,MONTH,DAY)='$V_PAR2DAYS'
				) B
		ON(A.PHONE= B.MSISDN)
		GROUP BY AREA
		GROUPING SETS(AREA,())
	    ) W
) B
ON(A.AREA=B.AREA)
;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/driver_updateapp/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS