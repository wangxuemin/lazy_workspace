#function description: 
#procedure name: P_DM_driver_wechat_collection
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

# 微信收款司机�? 当日微信收款司机�?
# 累积微信收款司机�? 历史所有使用微信收款的司机�?
# 微信收款司机占比  当日微信收款司机�?  当日在线司机�?
# 微信收款新增司机�? 当日首次使用微信收款司机�?
# 微信收款新增司机占比  微信收款新增司机�? /  微信收款司机�?
/home/xiaoju/hive-0.10.0/bin/hive -e"use app;
set hive.optimize.cp=true;
set hive.map.aggr=true;
set hive.groupby.mapaggr.checkinterval = 100000;
set hive.exec.parallel=true;
INSERT OVERWRITE TABLE DRIVER_WECHAT_COLLECTION PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0,
       '$V_YESTERDAY',
		A.AREA,
		0,
		A.TODAYWECHAT_DRIVERCNT,
		A.ALL_WECHAT_DRIVERCNT,
		(CASE WHEN B.DRIVERONLINE_CNT IS NOT NULL AND B.DRIVERONLINE_CNT <> 0 
				THEN ROUND(A.TODAYWECHAT_DRIVERCNT/B.DRIVERONLINE_CNT,3)
				ELSE 0.00 END) DRIVER_WECHAT_RATE,
		(CASE WHEN C.NEWADD_USE IS NOT NULL THEN C.NEWADD_USE ELSE CAST(0 AS BIGINT) END) DRIVER_WECHAT_NEWADD,
		(CASE WHEN C.NEWADD_USE IS NOT NULL AND A.TODAYWECHAT_DRIVERCNT <> 0 
				THEN ROUND(C.NEWADD_USE/A.TODAYWECHAT_DRIVERCNT,3)
				ELSE 0.00 END) DRIVER_WECHAT_NEWADDRATE
  FROM 	   
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
        TODAYWECHAT_DRIVERCNT,
		ALL_WECHAT_DRIVERCNT
  FROM (SELECT AREA,
			   COUNT(DISTINCT (CASE WHEN A.CREATE_TIME>='$V_YESTERDAY' AND A.CREATE_TIME <'$V_TODAY'  THEN A.DRIVERID ELSE 0 END))-1 TODAYWECHAT_DRIVERCNT,
			   COUNT(DISTINCT A.DRIVERID) ALL_WECHAT_DRIVERCNT
		  FROM PDW.WX_DRIVER_TRANSACTION A
		  JOIN (SELECT AREA,
					   DRIVERID
				  FROM PDW.DRIVER
				 WHERE YEAR='$V_PARYEAR'
				   AND MONTH='$V_PARMONTH'
				   AND DAY='$V_PARDAY') B
		  ON (A.DRIVERID = B.DRIVERID AND A.TRANS_TYPE = 1 AND A.PARTNER_TYPE = 1)
		GROUP BY AREA
		GROUPING SETS(AREA,())
		) W
) A
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
        DRIVERONLINE_CNT
  FROM (
		SELECT AREA,
			   COUNT(DISTINCT DID) DRIVERONLINE_CNT
		  FROM PDW.OP_STATICSTIC_DRIVER
		 WHERE YEAR='$V_PARYEAR'
		   AND MONTH='$V_PARMONTH'
		   AND DAY='$V_PARDAY'
		   AND OP_STATICSTIC_DRIVER_DATE ='$V_YESTERDAY'
		   AND ONLINETIME > 0
		GROUP BY AREA
		GROUPING SETS(AREA,())
		) W
) B
ON(A.AREA=B.AREA)
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
		NEWADD_USE
  FROM (SELECT AREA,
			   COUNT(DISTINCT A.DRIVERID) NEWADD_USE
		  FROM 
		(
		SELECT DISTINCT DRIVERID
		  FROM PDW.WX_DRIVER_TRANSACTION
		 WHERE YEAR='$V_PARYEAR'
		   AND MONTH='$V_PARMONTH'
		   AND DAY='$V_PARDAY'
		) A
		LEFT OUTER JOIN
		(
		SELECT DISTINCT DRIVERID
		  FROM PDW.WX_DRIVER_TRANSACTION
		 WHERE CONCAT(YEAR,MONTH,DAY)<'20140211'
		) B
		ON ( A.DRIVERID = B.DRIVERID)
		JOIN
		(
		SELECT AREA,
			   DRIVERID
		  FROM PDW.DRIVER
		 WHERE YEAR='$V_PARYEAR'
		   AND MONTH='$V_PARMONTH'
		   AND DAY='$V_PARDAY') C
		ON (A.DRIVERID = C.DRIVERID)
		WHERE B.DRIVERID IS NULL 
		GROUP BY AREA
		GROUPING SETS(AREA,())
		) W
) C
ON(A.AREA=C.AREA)
;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/driver_wechat_collection/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS
	   