
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
V_PARDAY2=`date --date="$V_DATE-2 day" +%d`
V_PARYESTERDAY=`date --date="$V_DATE-1 day" +%Y%m%d`
#today,yesterday,7 day  ago,30 days ago,2 days ago  date
V_TODAY=`date -d $V_DATE "+%Y-%m-%d"`
V_YESTERDAY=`date --date="$V_DATE-1 day" +%Y-%m-%d`
V_YESTER7DAY=`date --date="$V_DATE-7 day" +%Y-%m-%d`
V_YESTER30DAY=`date --date="$V_DATE-30 day" +%Y-%m-%d`
echo "execute data date=$V_YESTERDAY V_YESTER7DAY=$V_YESTER7DAY V_YESTER30DAY=$V_YESTER30DAY"
/home/xiaoju/hive-0.10.0/bin/hive -e"
set hive.optimize.cp=true;
set hive.map.aggr=true;
set hive.groupby.mapaggr.checkinterval = 100000;
set hive.exec.parallel=true;

use app;
insert OVERWRITE table newdrivercheckdata PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
select 
	0 as statid ,
    '$V_YESTERDAY' as statdate,
	(case when area is null then 10000 else cast(area as int) end) as area,
    0 as channel,
	 sum(case when regdate = '$V_YESTERDAY'  and checkdate = '$V_YESTERDAY' then  1 else 0 end) as newcheckcnt,
	 sum(case when checkdate = '$V_YESTERDAY' and  reporttime is not null then  1 else 0 end) as newactivecnt,
	 sum(case when regdate >= '$V_YESTER7DAY'  and regdate <= '$V_YESTERDAY' and checkdate >= '$V_YESTER7DAY' and checkdate <= '$V_YESTERDAY' then  1 else 0 end) as weeknewcheckcnt,
	 sum(case when checkdate >= '$V_YESTER7DAY' and checkdate <= '$V_YESTERDAY' and  reporttime is not null then  1 else 0 end) as weeknewactivecnt,
	 sum(case when regdate >= '$V_YESTER30DAY'  and regdate <= '$V_YESTERDAY' and checkdate >= '$V_YESTER30DAY' and checkdate <= '$V_YESTERDAY' then  1 else 0 end) as monthnewcheckcnt,
	 sum(case when checkdate >= '$V_YESTER30DAY' and checkdate <= '$V_YESTERDAY' and  reporttime is not null then  1 else 0 end) as monthnewactivecnt
from pdw.driver 
where year='$V_PARYEAR' and month='$V_PARMONTH' and day='$V_PARDAY'
group by area
grouping sets(area,())
;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/newdrivercheckdata/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS


