#function description:
# 1. WX ALLOWANCE FEE (DRIVER + PASSENGER)
# 2. PASSENGER PAY FEE
# 3. LJ ORDER NUM 

#procedure name: P_DM_WX_MONEY_PAY 
#creator: mayiming
#created:
#!/bin/bash

#today date
V_DATE=$1
##
if [ -z ${V_DATE} ];then
  V_DATE=`date +%Y-%m-%d`
fi

#yesterday data partition
V_PARYEAR=`date --date="$V_DATE-1 day" +%Y`
V_PARMONTH=`date --date="$V_DATE-1 day" +%m`
V_PARDAY=`date --date="$V_DATE-1 day" +%d`

/home/xiaoju/hive-0.10.0/bin/hive -e"use app;
ALTER TABLE LJ_PASSENGER ADD IF NOT EXISTS PARTITION (YEAR = '$V_PARYEAR',MONTH = '$V_PARMONTH',DAY = '$V_PARDAY') LOCATION '/user/xiaoju/data/bi/app/lj_passenger/$V_PARYEAR/$V_PARMONTH/$V_PARDAY';
INSERT OVERWRITE TABLE LJ_PASSENGER PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0 STATID,
       '${V_PARYEAR}-${V_PARMONTH}-${V_PARDAY}' STATDATE,
       CASE WHEN AREA IS NULL THEN 10000 ELSE AREA END AREA,
       0 CHANNEL,
       ROUND(SUM(LJ_PASSENGER_FEE)/COUNT(DISTINCT PASSENGER_PHONE)/100,2) LJ_FEE_AVE,
       ROUND(SUM(LJ_PASSENGER_ORDER)/COUNT(DISTINCT PASSENGER_PHONE),3) LJ_ORDER_AVE,
       SUM(ONE_ORDER) ONE_ORDER,
       SUM(TWO_ORDER) TWO_ORDER,
       SUM(THREE_ORDER) THREE_ORDER,
       SUM(MORE_ORDER) MORE_ORDER,
       SUM(LJ_ORDER_0) LJ_ORDER_0,
       SUM(LJ_ORDER_0_5) LJ_ORDER_0_5,
       SUM(LJ_ORDER_5_10) LJ_ORDER_5_10,
       SUM(LJ_ORDER_10_20) LJ_ORDER_10_20,
       SUM(LJ_ORDER_20_30) LJ_ORDER_20_30,
       SUM(LJ_ORDER_30) LJ_ORDER_30
FROM 
(SELECT AREA,
        PASSENGER_PHONE,
        SUM(TOTAL_FEE) PASSENGER_PAY,
        SUM(CASE WHEN COUPONID >= 2 AND COUPONID < 100 THEN (COST - TOTAL_FEE) ELSE 0 END) LJ_PASSENGER_FEE,
        SUM(CASE WHEN COUPONID >= 2 AND COUPONID < 100 THEN 1 ELSE 0 END) LJ_PASSENGER_ORDER,
        CASE WHEN COUNT(1) = 1 THEN 1 ELSE 0 END ONE_ORDER,
        CASE WHEN COUNT(1) = 2 THEN 1 ELSE 0 END TWO_ORDER,
        CASE WHEN COUNT(1) = 3 THEN 1 ELSE 0 END THREE_ORDER,
        CASE WHEN COUNT(1) > 3 THEN 1 ELSE 0 END MORE_ORDER,
        SUM(CASE WHEN COUPONID >= 2 AND COUPONID < 100 AND TOTAL_FEE = 1 THEN 1 ELSE 0 END) LJ_ORDER_0,
        SUM(CASE WHEN COUPONID >= 2 AND COUPONID < 100 AND TOTAL_FEE > 1 AND TOTAL_FEE <= 500 THEN 1 ELSE 0 END) LJ_ORDER_0_5,
        SUM(CASE WHEN COUPONID >= 2 AND COUPONID < 100 AND TOTAL_FEE > 500 AND TOTAL_FEE <= 1000 THEN 1 ELSE 0 END) LJ_ORDER_5_10,
        SUM(CASE WHEN COUPONID >= 2 AND COUPONID < 100 AND TOTAL_FEE > 1000 AND TOTAL_FEE <= 2000 THEN 1 ELSE 0 END) LJ_ORDER_10_20,
        SUM(CASE WHEN COUPONID >= 2 AND COUPONID < 100 AND TOTAL_FEE > 2000 AND TOTAL_FEE <= 3000 THEN 1 ELSE 0 END) LJ_ORDER_20_30,
        SUM(CASE WHEN COUPONID >= 2 AND COUPONID < 100 AND TOTAL_FEE > 3000 THEN 1 ELSE 0 END) LJ_ORDER_30 
 FROM PDW.WX_DIDI_TRANSACTION 
 WHERE YEAR ='$V_PARYEAR' 
 AND MONTH ='$V_PARMONTH' 
 AND DAY = '$V_PARDAY' 
 AND STATUS = 1 
 AND TRANS_TYPE = 1
 GROUP BY AREA,PASSENGER_PHONE
) A 
GROUP BY AREA
GROUPING SETS (AREA,
                 ())
;"

/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/lj_passenger/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS
