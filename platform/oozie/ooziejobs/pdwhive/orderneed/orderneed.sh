#function description: 
#procedure name: P_DM_orderneed
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
# (STATID                  INT,
# STATDATE          STRING,
# area               	             INT          ,
# channel            	             INT          ,
# orderNeedCnt       	             INT          ,
# orderNeedAnswerCnt 	             INT          ,
# orderNeedSuccCnt   	             INT          ,
# orderNeedSuccRate  	             FLOAT
# )
/home/xiaoju/hive-0.10.0/bin/hive -e"use app;
INSERT OVERWRITE TABLE ORDERNEED PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0,
	   '$V_YESTERDAY',
	   M.AREA,
	   M.CHANNEL,
	   (CASE WHEN A.ORDERNEEDCNT IS NULL THEN 0 ELSE CAST(A.ORDERNEEDCNT AS INT) END),
	   (CASE WHEN A.ORDERNEEDANSWERCNT IS NULL THEN 0 ELSE CAST(A.ORDERNEEDANSWERCNT AS INT) END),
	   (CASE WHEN A.ORDERNEEDSUCCCNT IS NULL THEN 0 ELSE CAST(A.ORDERNEEDSUCCCNT AS INT) END),
	   (CASE WHEN A.ORDERNEEDSUCCRATE IS NULL THEN 0.000 ELSE A.ORDERNEEDSUCCRATE END)
  FROM PDW.PASSENGER_AREA_CHANNEL M
LEFT OUTER JOIN
(
SELECT AREA,
       CHANNEL,
	   ORDERNEEDCNT,
	   ORDERNEEDANSWERCNT,
	   ORDERNEEDSUCCCNT,
	   ORDERNEEDSUCCRATE
  FROM (SELECT AREA,
			   0 CHANNEL,
			   SUM(NEEDNUM) ORDERNEEDCNT,
			   SUM(ORDERNEEDANSWERCNT) ORDERNEEDANSWERCNT,
			   SUM(NEEDSUCCNUM) ORDERNEEDSUCCCNT,
			   (CASE WHEN SUM(NEEDNUM)<>0 THEN ROUND(SUM(NEEDSUCCNUM)/SUM(NEEDNUM),3) ELSE 0.00 END)ORDERNEEDSUCCRATE 
		  FROM (SELECT AREA,
					   2 CHANNEL,
					   NEEDNUM ,
					   0 ORDERNEEDANSWERCNT,
					   NEEDSUCCNUM 
				  FROM PDW.ORDER_STAT
				 WHERE YEAR='$V_PARYEAR'
				   AND MONTH='$V_PARMONTH'
				   AND DAY='$V_PARDAY'
				   AND STATDATE = '$V_YESTERDAY'
                                    AND AREA IS NOT NULL
				) AA
		  GROUP BY AREA
	   UNION ALL
		SELECT 10000 AREA,
			   CHANNEL,
			   SUM(NEEDNUM) ORDERNEEDCNT,
			   SUM(ORDERNEEDANSWERCNT) ORDERNEEDANSWERCNT,
			   SUM(NEEDSUCCNUM) ORDERNEEDSUCCCNT,
			   (CASE WHEN SUM(NEEDNUM)<>0 THEN ROUND(SUM(NEEDSUCCNUM)/SUM(NEEDNUM),3) ELSE 0.00 END) ORDERNEEDSUCCRATE
		  FROM (SELECT AREA,
					   2 CHANNEL,
					   NEEDNUM ,
					   0 ORDERNEEDANSWERCNT,
					   NEEDSUCCNUM 
				  FROM PDW.ORDER_STAT
				 WHERE YEAR='$V_PARYEAR'
				   AND MONTH='$V_PARMONTH'
				   AND DAY='$V_PARDAY'
				   AND STATDATE = '$V_YESTERDAY'
				) BB
		  GROUP BY CHANNEL		
	   UNION ALL
			SELECT AREA,
				   2 CHANNEL,
				   NEEDNUM  ORDERNEEDCNT,
				   0 ORDERNEEDANSWERCNT,
				   NEEDSUCCNUM ORDERNEEDSUCCCNT,
				   (CASE WHEN NEEDNUM <>0 THEN ROUND(NEEDSUCCNUM/NEEDNUM,3)  ELSE 0.00 END) ORDERNEEDSUCCRATE
			  FROM PDW.ORDER_STAT
			 WHERE YEAR='$V_PARYEAR'
			   AND MONTH='$V_PARMONTH'
			   AND DAY='$V_PARDAY'
			   AND STATDATE = '$V_YESTERDAY'
                            AND AREA IS NOT NULL
            UNION ALL
                SELECT  10000 AREA,
		        0 CHANNEL,
		        SUM(NEEDNUM) ORDERNEEDCNT,
			    SUM(ORDERNEEDANSWERCNT) ORDERNEEDANSWERCNT,
			    SUM(NEEDSUCCNUM) ORDERNEEDSUCCCNT,
			    (CASE WHEN SUM(NEEDNUM) <>0 THEN ROUND(SUM(NEEDSUCCNUM)/SUM(NEEDNUM),3) ELSE 0.00 END) ORDERNEEDSUCCRATE
		  FROM (SELECT AREA,
					   2 CHANNEL,
					   NEEDNUM ,
					   0 ORDERNEEDANSWERCNT,
					   NEEDSUCCNUM 
				  FROM PDW.ORDER_STAT
				 WHERE YEAR='$V_PARYEAR'
				   AND MONTH='$V_PARMONTH'
				   AND DAY='$V_PARDAY'
				   AND STATDATE = '$V_YESTERDAY'
                                    AND AREA IS NOT NULL
			) CC
		) D
)  A
ON ( M.AREA=A.AREA AND M.CHANNEL=A.CHANNEL)
;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/orderneed/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS