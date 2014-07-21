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
V_PARDAY2=`date --date="$V_DATE-2 day" +%d`
V_PARYESTERDAY=`date --date="$V_DATE-1 day" +%Y%m%d`
#today,yesterday,7 day  ago,30 days ago,2 days ago  date
V_TODAY=`date -d $V_DATE "+%Y-%m-%d"`
V_YESTERDAY=`date --date="$V_DATE-1 day" +%Y-%m-%d`
echo "execute data date=$V_YESTERDAY"
/home/xiaoju/hive-0.10.0/bin/hive -e"
set hive.optimize.cp=true;
set hive.map.aggr=true;
set hive.groupby.mapaggr.checkinterval = 100000;
set hive.exec.parallel=true;
use pdw;
INSERT OVERWRITE TABLE app.passenger_needdata PARTITION(YEAR='$V_PARYEAR',MONTH='$V_PARMONTH',DAY='$V_PARDAY')
select 
	0,
  '$V_YESTERDAY',
  M.area,
	stctotalneedcnt,
	btjpassengercnt,
	btjpassenger2cnt,
	(case when btjpassengercnt=0 then 0.00 else  Round(btjpassenger2cnt/btjpassengercnt,3) end) as btjpassenger2z1rate,
	(case when regcnt=0 then 0.00 else Round(regneed1cnt/regcnt,3) end) as nobtjpassenger1ztotlrate,
	(case when nobtjpassengercnt=0 then 0.00 else Round(regneed2cnt/nobtjpassengercnt,3) end) as nobtjpassenger2z1rate
	
from

	(
		select
			(case when W.area is null then 10000 else cast(W.area as int) end) as area,
			sum(case when C.pid is not null then  W.needcnt else 0 end) as stctotalneedcnt,
			count(distinct case when C.pid is not null and  W.needcnt = 1 then W.pid else '0' end)-1 as btjpassengercnt,
			count(distinct case when C.pid is not null and  W.needcnt >= 2 then W.pid else '0' end)-1 as btjpassenger2cnt,
			count(distinct case when C.pid is not null  then W.pid else '0' end)-1 as btjpassengertotalcnt,
			count(distinct case when C.pid is null and  W.needcnt = 1 then W.pid else '0' end)-1 as nobtjpassengercnt,
			count(distinct case when C.pid is null and  W.needcnt >= 2 then W.pid else '0' end)-1 as nobtjpassenger2cnt,
			count(distinct case when C.pid is null then W.pid else '0' end)-1 as nobtjpassengertotalcnt
		from 
		(
			select 
				area,pid,needcnt
			from passengerneedcnt
			where  year='$V_PARYEAR' and month='$V_PARMONTH' and day='$V_PARDAY'
		) W
		left outer join
		(
			select
				A.pid as pid,
				A.regtime
			from 
			(select 
				pid,phone,regtime
			from passenger
			where year= '$V_PARYEAR' and month= '$V_PARMONTH' and day='$V_PARDAY'
			) A
			join 
			(select 
			 		phone
			from recommend 
			where year= '$V_PARYEAR' and month= '$V_PARMONTH' and day='$V_PARDAY' and type=1
			) B
			ON A.phone = B.phone
		) C
		ON W.pid = C.pid
		group by W.area
		GROUPING SETS (W.area,())
	) M
	LEFT OUTER JOIN
	(
			select 
			(case when A.area is null then 10000 else cast(A.area as int) end) as area,
			count(distinct case when C.pid is not null and C.needcnt =1 then A.pid else '0' end)-1 as regneed1cnt,
			count(distinct case when C.pid is not null and C.needcnt >=2 then A.pid else '0' end)-1 as regneed2cnt,
			count(distinct case when B.phone is null then A.pid else '0' end)-1 as regcnt
		from
			(
				select 
					area,pid,phone
				from passenger 
				where year= '$V_PARYEAR' and month= '$V_PARMONTH' and day='$V_PARDAY' and regtime >= '$V_YESTERDAY 00:00:00' and regtime<='$V_YESTERDAY 23:59:59'
			) A
			left outer join
			(
				select 
					phone
				from  recommend 
				where year= '$V_PARYEAR' and month= '$V_PARMONTH' and day='$V_PARDAY' and type=1
			) B
			ON A.phone = B.phone
			left outer join
			(
				select 
					pid,needcnt
				from passengerneedcnt
				where  year='$V_PARYEAR' and month='$V_PARMONTH' and day='$V_PARDAY'
			) C
			ON A.pid = C.pid
			group by A.area
			GROUPING SETS (A.area,())
	) N
	ON M.area = N.area

;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/passenger_needdata/$V_PARYEAR/$V_PARMONTH/$V_PARDAY/_SUCCESS
