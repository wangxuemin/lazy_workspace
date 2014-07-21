#function description: order stat by month 
#author:mayiming

#!/bin/bash

exe_hive="/home/xiaoju/hive-0.10.0/bin/hive"

V_PARYEAR=`date --date="last month" +%Y`
V_PARMONTH=`date --date="last month" +%m`

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

$exe_hive -S -e  "use app;
    ALTER TABLE INVESTOR_ORDER_MONTH ADD IF NOT EXISTS PARTITION (YEAR = '$V_PARYEAR',MONTH = '$V_PARMONTH') LOCATION '$V_PARYEAR/$V_PARMONTH';
    INSERT OVERWRITE TABLE INVESTOR_ORDER_MONTH PARTITION(YEAR = '$V_PARYEAR',MONTH = '$V_PARMONTH') 
    SELECT 0 STATID,
           '${V_PARYEAR}-${V_PARMONTH}-01' STATDATE,
           CASE WHEN AREA is NULL THEN '10000' ELSE AREA END,
           ORDERCNT,
           REALORDERSUCCNT + PREORDERSUCCNT ORDERSUCCNT,
           CASE WHEN ORDERCNT = 0 THEN 0.0 ELSE ROUND((REALORDERSUCCNT + PREORDERSUCCNT)/ORDERCNT,3) END ORDERSUCRATE,
           REALORDERCNT,
           REALORDERSUCCNT,
           CASE WHEN REALORDERCNT = 0 THEN 0.0 ELSE ROUND(REALORDERSUCCNT/REALORDERCNT,3) END REALORDERSUCRATE,
           PREORDERCNT,
           PREORDERSUCCNT,
           CASE WHEN PREORDERCNT = 0 THEN 0.0 ELSE ROUND(PREORDERSUCCNT/PREORDERCNT,3) END PREORDERSUCRATE,
           ORDERTIPSUCCNT,
           ORDERTIP
    FROM (
          SELECT AREA, 
                 COUNT(1) ORDERCNT,
                 SUM(CASE WHEN TYPE = 0 THEN 1 ELSE 0 END) REALORDERCNT,
                 SUM(CASE WHEN TYPE = 0 AND (STATUS >= 1 AND STATUS <= 3 OR (STATUS = 4 AND DRIVERID > 0)) THEN 1 ELSE 0 END) REALORDERSUCCNT,
                 SUM(CASE WHEN TYPE = 1 THEN 1 ELSE 0 END) PREORDERCNT,
                 SUM(CASE WHEN TYPE = 1 AND (STATUS >= 1 AND STATUS <= 3 OR (STATUS = 4 AND DRIVERID > 0)) THEN 1 ELSE 0 END) PREORDERSUCCNT,
                 SUM(CASE WHEN TIP > 0 AND (STATUS >= 1 AND STATUS <= 3 OR (STATUS = 4 AND DRIVERID > 0)) THEN 1 ELSE 0 END) ORDERTIPSUCCNT,
                 SUM(CASE WHEN TIP > 0 AND (STATUS >= 1 AND STATUS <= 3 OR (STATUS = 4 AND DRIVERID > 0)) THEN CAST(TIP as INT) ELSE 0 END) ORDERTIP 
          FROM PDW.DW_ORDER  
          WHERE YEAR ='$V_PARYEAR'
            AND MONTH ='$V_PARMONTH'
          GROUP BY AREA 
          GROUPING SETS (AREA,
                          ())
         ) a;" 

/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/investor_order_month/$V_PARYEAR/$V_PARMONTH/_SUCCESS
