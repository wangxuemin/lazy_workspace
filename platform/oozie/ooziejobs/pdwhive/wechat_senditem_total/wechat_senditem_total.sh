#function description:
# 1.total people who send items
# 2.total items
# 3.total left items
# 4.total people who do not share items
# 5.total not share items

#procedure name: P_DM_wechat_senditem_total 
#creator: mayiming
#created:
#!/bin/bash
#today date
V_DATE=$1
#
if [ -z ${V_DATE} ];then
        V_DATE=`date +%Y-%m-%d`
fi
#
#yesterday data partition
V_PARYEAR=`date --date="$V_DATE-1 day" +%Y`
V_PARMONTH=`date --date="$V_DATE-1 day" +%m`
V_PARDAY=`date --date="$V_DATE-1 day" +%d`
V_PARYESTERDAY=`date --date="$V_DATE-1 day" +%Y%m%d`

#yesterday date 
V_YESTERDAY=`date --date="$V_DATE-1 day" +%Y-%m-%d`

/home/xiaoju/hive-0.10.0/bin/hive -e"use app;
ALTER TABLE WECHAT_SENDITEM_TOTAL ADD IF NOT EXISTS PARTITION (YEAR = '$V_PARYEAR',MONTH = '$V_PARMONTH',DAY = '$V_PARDAY') LOCATION '/user/xiaoju/data/bi/app/wechat_senditem_total/$V_PARYEAR/$V_PARMONTH/$V_PARDAY';
INSERT OVERWRITE TABLE WECHAT_SENDITEM_TOTAL PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
SELECT 0 STATID,
       '${V_PARYEAR}-${V_PARMONTH}-${V_PARDAY}' STATDATE,
       AREA,
       0 CHANNEL,
       SUM(PASSENGER_SHARE),
       SUM(ITEMS_SHARE),
       SUM(LEFT_ITEMS),
       SUM(PASSENGER_NOTSHARE),
       SUM(ITEMS_NOTSHARE)
FROM 
(
 SELECT CASE WHEN AREA is NULL THEN '10000' ELSE AREA END AREA, 
         COUNT(DISTINCT PHONE) PASSENGER_SHARE,
         SUM(CNT_ITEMS) ITEMS_SHARE,
         SUM(LEFT_ITEMS) LEFT_ITEMS,
         0 PASSENGER_NOTSHARE,
         0 ITEMS_NOTSHARE
  FROM PDW.WX_R_LIST_INFO 
  WHERE YEAR='$V_PARYEAR'
  AND MONTH='$V_PARMONTH'
  AND DAY='$V_PARDAY'
  AND CNT_ITEMS != LEFT_ITEMS
  GROUP BY AREA 
  GROUPING SETS (AREA,
                 ())
  UNION ALL 
  SELECT CASE WHEN AREA is NULL THEN '10000' ELSE AREA END AREA,
         0 PASSENGER_SHARE,
         0 ITEMS_SHARE,
         0 LEFT_ITEMS,
         COUNT(DISTINCT PHONE) PASSENGER_NOTSHARE,
         SUM(CNT_ITEMS) ITEMS_NOTSHARE
  FROM PDW.WX_R_LIST_INFO 
  WHERE YEAR='$V_PARYEAR'
  AND MONTH='$V_PARMONTH'
  AND DAY='$V_PARDAY'
  AND CNT_ITEMS = LEFT_ITEMS 
  GROUP BY AREA 
  GROUPING SETS (AREA,
                 ())
) C 
GROUP BY AREA 
;"

/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/wechat_senditem_total/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS
