#function description: 
#procedure name: p_dm_driverretentionrates
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
ENDTIME_7=`date --date="$V_DATE-7 day" +%Y-%m-%d`
ENDTIME_30=`date --date="$V_DATE-30 day" +%Y-%m-%d`
#30 days ago, 2 days ago data partition 
V_PAR7DAYS=`date --date="$V_DATE-7 day" +%Y%m%d`
V_PAR15DAYS=`date --date="$V_DATE-15 day" +%Y%m%d`
V_PAR30DAYS=`date --date="$V_DATE-30 day" +%Y%m%d`
V_PAR2DAYS=`date --date="$V_DATE-2 day" +%Y%m%d`
#$data[$key]['save_ratio'] = round($data[$key]['driver_7online_bef7']/$data[$key]['driver_reg_7'],2); 
#$data[$key]['nobdsave_ratio'] = round($data[$key]['driver_nobd_7online_bef7']/$data[$key]['driver_nobdreg_7'],2); 
#$data[$key]['bdsave_ratio'] = round($data[$key]['driver_bd_7online_bef7']/$data[$key]['driver_bdreg_7'],2); 
/home/xiaoju/hive-0.10.0/bin/hive -e"use app;
INSERT OVERWRITE TABLE DRIVERRETENTIONRATES PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0,
       '$V_YESTERDAY',
	    M.CITYID,
		0,
		(CASE WHEN A.DRIVER_7ONLINE_BEF7 IS NOT NULL AND A.DRIVER_REG_7 IS NOT NULL AND A.DRIVER_REG_7 <> 0 
		       THEN ROUND(A.DRIVER_7ONLINE_BEF7/A.DRIVER_REG_7,3)
			  ELSE 0.000
			  END) SAVE_RATIO,
		(CASE WHEN A.DRIVER_30ONLINE_BEF30 IS NOT NULL AND A.DRIVER_REG_30 IS NOT NULL AND A.DRIVER_REG_30 <> 0
		       THEN ROUND(A.DRIVER_30ONLINE_BEF30/A.DRIVER_REG_30,3)
			  ELSE 0.000
			  END) MONTH_SAVE_RATIO,
		(CASE WHEN A.DRIVER_NOBD_7ONLINE_BEF7 IS NOT NULL AND A.DRIVER_NOBDREG_7 IS NOT NULL AND A.DRIVER_NOBDREG_7 <> 0 
		       THEN ROUND(A.DRIVER_NOBD_7ONLINE_BEF7/A.DRIVER_NOBDREG_7,3)
			  ELSE 0.000
			  END) NOBDSAVE_RATIO,
		(CASE WHEN A.DRIVER_BD_7ONLINE_BEF7 IS NOT NULL AND A.DRIVER_BDREG_7 IS NOT NULL AND A.DRIVER_BDREG_7 <> 0 
		       THEN ROUND(A.DRIVER_BD_7ONLINE_BEF7/A.DRIVER_BDREG_7,3)
			  ELSE 0.000
			  END) BDSAVE_RATIO
  FROM (SELECT CITYID FROM PDW.CITY WHERE YEAR='$V_PARYEAR' AND MONTH='$V_PARMONTH' AND DAY='$V_PARDAY') M
LEFT OUTER JOIN
(
SELECT (CASE WHEN AREA IS NULL THEN 10000 ELSE CAST(AREA AS INT) END) AREA,
       DRIVER_7ONLINE_BEF7,
	   DRIVER_REG_7,
	   DRIVER_30ONLINE_BEF30,
	   DRIVER_REG_30,
	   DRIVER_NOBD_7ONLINE_BEF7,
	   DRIVER_NOBDREG_7,
	   DRIVER_BD_7ONLINE_BEF7,
	   DRIVER_BDREG_7
  FROM (SELECT AREA,
			   SUM(CASE WHEN REGTIME<='$ENDTIME_7' AND REPORTTIME>='$ENDTIME_7' THEN 1
						ELSE 0
						END) DRIVER_7ONLINE_BEF7,
			   SUM(CASE WHEN REGTIME <= '$ENDTIME_7' AND STATUS=1 AND CHANNEL!=1 THEN 1
						ELSE 0
						END) DRIVER_REG_7,
			   SUM(CASE WHEN REGTIME<='$ENDTIME_30' AND REPORTTIME>='$ENDTIME_30' THEN 1
						ELSE 0
						END) DRIVER_30ONLINE_BEF30,
			   SUM(CASE WHEN REGTIME <= '$ENDTIME_30' AND STATUS=1 AND CHANNEL!=1 THEN 1
						ELSE 0
						END) DRIVER_REG_30,
			   SUM(CASE WHEN REGTIME<='$ENDTIME_7' AND REPORTTIME>='$ENDTIME_7' AND CHANNEL!=1 AND STATUS=1 AND SOURCE=0 THEN 1
						ELSE 0
						END) DRIVER_NOBD_7ONLINE_BEF7,
			   SUM(CASE WHEN REGTIME <= '$ENDTIME_7' AND STATUS=1 AND CHANNEL!=1 AND SOURCE=0 THEN 1
						ELSE 0
						END) DRIVER_NOBDREG_7,
			   SUM(CASE WHEN REGTIME<='$ENDTIME_7' AND REPORTTIME>='$ENDTIME_7' AND SOURCE>0 THEN 1
						ELSE 0
						END) DRIVER_BD_7ONLINE_BEF7,
			   SUM(CASE WHEN REGTIME <= '$ENDTIME_7' AND STATUS=1 AND CHANNEL!=1 AND SOURCE>0 THEN 1
						ELSE 0
						END) DRIVER_BDREG_7		
		  FROM PDW.DRIVER
		 WHERE YEAR='$V_PARYEAR'
		   AND MONTH='$V_PARMONTH'
		   AND DAY='$V_PARDAY'
		GROUP BY AREA
		GROUPING SETS (AREA,
					   ())
		) W
) A
ON(M.CITYID=A.AREA)
;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/driverretentionrates/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS