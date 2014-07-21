#function description: 
#procedure name: P_DM_todaydriver6houronline_dprate 
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
INSERT OVERWRITE TABLE TODAYDRIVER6HOURONLINE_DPRATE PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0,
       '$V_YESTERDAY',
	    M.CITYID AREA,
		0,
		(CASE WHEN B.DRIVER_STRIVE IS NOT NULL THEN CAST(B.DRIVER_STRIVE AS INT) ELSE 0 END) DRIVER_STRIVE,
		(CASE WHEN E.NEEDNUM IS NOT NULL AND C.DRIVER_ONLINE IS NOT NULL AND C.DRIVER_ONLINE <> 0 
		        THEN ROUND(E.NEEDNUM/C.DRIVER_ONLINE,3)
			ELSE 0.000
			END) DP_RATIO
  FROM  (SELECT CITYID FROM PDW.CITY WHERE YEAR='$V_PARYEAR' AND MONTH='$V_PARMONTH' AND DAY='$V_PARDAY') M
LEFT OUTER JOIN
(	
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
        DRIVER_STRIVE
  FROM (SELECT AREA,
			   COUNT(DISTINCT DPHONE) DRIVER_STRIVE
		  FROM PDW.OP_STATICSTIC_DRIVER
		 WHERE YEAR='$V_PARYEAR'
		   AND MONTH='$V_PARMONTH'
		   AND DAY='$V_PARDAY'
		   AND OP_STATICSTIC_DRIVER_DATE='$V_YESTERDAY'
		   AND SUMORDER>0
                    AND ONLINETIME > 0
		GROUP BY AREA
		GROUPING SETS (AREA,
					   ())
		) W
) B
ON(M.CITYID=B.AREA )
LEFT OUTER JOIN
(				
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
        DRIVER_ONLINE
  FROM (SELECT AREA,
			   COUNT(DISTINCT DPHONE) DRIVER_ONLINE
		  FROM PDW.OP_STATICSTIC_DRIVER
		 WHERE YEAR='$V_PARYEAR'
		   AND MONTH='$V_PARMONTH'
		   AND DAY='$V_PARDAY'
		   AND OP_STATICSTIC_DRIVER_DATE='$V_YESTERDAY'
		   AND ONLINETIME > 0
		GROUP BY AREA
		GROUPING SETS (AREA,
					   ())
		) W
) C
ON(M.CITYID=C.AREA)
LEFT OUTER JOIN
(
SELECT AREA,
       TOTALNEED_NUM  NEEDNUM
  FROM APP.PASSENGERORDER
  WHERE YEAR='$V_PARYEAR'
    AND MONTH='$V_PARMONTH'
	AND DAY='$V_PARDAY'
) E
ON(M.CITYID=E.AREA)
;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/todaydriver6houronline_dprate/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS