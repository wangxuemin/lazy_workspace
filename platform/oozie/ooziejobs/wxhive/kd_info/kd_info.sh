#!/bin/sh
if [ $# -eq 1 ];then
   nowdate=$1
else
  nowdate=`date --date "-1 day" "+%Y/%m/%d"`
fi
 echo $nowdate
 predate=`date --date "${nowdate} -1 day" "+%Y/%m/%d"`
 echo $predate
  
y=${nowdate:0:(4)}
mon=${nowdate:5:(2)}
day=${nowdate:8:(2)} 
/home/xiaoju/hive-0.10.0/bin/hive -e "INSERT OVERWRITE TABLE app.kd_info partition(year='$y',month='$mon',day='$day') 
select '0','$y-$mon-$day',c.area,'0',c1.testdrivers,c.kdonlinedrivers,c.kdinstalldrivers,c.onlinedrivers 
	from
(select case when b.area='' or b.area is null then '10000' else b.area end as area,
		 count(distinct (case when a.pkg='1' and (a.request_api like '%d_polling' or a.request_api like '%d_push_dispatch') then b.driverid else 0 end)) as kdonlinedrivers,
		 count(distinct (case when (a.pkg='1' or a.pkg='0') and (a.request_api like '%d_polling' or a.request_api like '%d_push_dispatch') then b.driverid  else 0 end)) as kdinstalldrivers,
		 count(distinct (case when  a.request_api like '%d_polling' then b.driverid  else 0 end)) as onlinedrivers
		 from 
		 (select request_api,param['pkg'] as pkg,cast(substr(param['token'],length(param['token'])-8,length(param['token'])) as bigint) as driverid
		 from ods.ods_log_nginx 
		 where year='$y' and month='$mon' and day='$day') a 
		 join 
		 (select 
		 area,driverid 
		 from 
		 pdw.driver 
		 where year='$y' and month='$mon' and day='$day') b
		 on a.driverid=b.driverid
		 group by  b.area
		 grouping sets (b.area,())) c
		 join  
		(select case when b.area='' or b.area is null then '10000' else b.area end as area,
		count(distinct a.userphone) as testdrivers from 
		(select 
			userphone 
		from 
		ods.ods_log_pushserver_monitorinfo 
		where year='$y' and month='$mon' and day='$day') a
		 join 
		 (select 
		 area,msisdn 
		 from 
		 pdw.driver 
		 where year='$y' and month='$mon' and day='$day') b
		 on a.userphone=b.msisdn
		 group by  b.area
		 grouping sets (b.area,())) c1
		 on c.area=c1.area"
		 
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/kd_info/$nowdate/_SUCCESS
