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

function parseArgs()
{ 
  args=($@)
  arglen=$#

  for (( i=0; i < $arglen; i+=2 )) ;do 
    arg=${args[$i]}

    if [ $arg == "-y" ] ;then
      V_PARYEAR=${args[$i+1]}
    elif [ $arg == "-m" ]   ;then
      V_PARMONTH=${args[$i+1]}
    elif [ $arg == "-d" ]  ;then
      V_PARDAY=${args[$i+1]}
    fi  
  done
}

# Start from here.
parseArgs $@

/home/xiaoju/hive-0.10.0/bin/hive -e"use app;
ALTER TABLE WX_MONEY_PAY ADD IF NOT EXISTS PARTITION (YEAR = '$V_PARYEAR',MONTH = '$V_PARMONTH',DAY = '$V_PARDAY') LOCATION '$V_PARYEAR/$V_PARMONTH/$V_PARDAY';
INSERT OVERWRITE TABLE WX_MONEY_PAY PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0 STATID,
       '${V_PARYEAR}-${V_PARMONTH}-${V_PARDAY}' STATDATE,
       A.AREA,
       0 CHANNEL,
       A.WX_ALLOWANCE,
       A.PASSENGER_PAY,
       CASE WHEN B.ORDER_NUM IS NULL THEN CAST('0' AS BIGINT) ELSE B.ORDER_NUM END LJ_ORDER_NUM
FROM 
(SELECT AREA,
       SUM(DRIVER_MONEY + TOTAL_P_COST) WX_ALLOWANCE,
       SUM(WEPAY_TOTAL_SUCC_COST - TOTAL_P_COST) PASSENGER_PAY
FROM APP.WX_MONEY_DATA 
WHERE YEAR = '$V_PARYEAR' 
AND MONTH = '$V_PARMONTH' 
AND DAY = '$V_PARDAY' 
GROUP BY AREA 
) A
LEFT OUTER JOIN 
(SELECT 
        CASE WHEN AREA IS NULL THEN 10000 ELSE AREA END AREA,
        COUNT(DISTINCT ORDERID) ORDER_NUM
 FROM PDW.WX_DIDI_TRANSACTION 
 WHERE YEAR ='$V_PARYEAR' 
 AND MONTH ='$V_PARMONTH' 
 AND DAY = '$V_PARDAY' 
 AND STATUS = 1 
 AND TRANS_TYPE = 1
 AND COUPONID >1 
 AND COUPONID < 100
 GROUP BY AREA
 GROUPING SETS (AREA,
                  ())
) B 
ON (A.AREA=B.AREA)
;"

/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/wx_money_pay/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS
