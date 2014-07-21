#function description: 
#procedure name: driveractivedata
#creator:zhangjg
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
V_PARDAY2=`date --date="$V_DATE-2 day" +%d`
V_PARYESTERDAY=`date --date="$V_DATE-1 day" +%Y%m%d`

V_TODAYMONTH=`date -d $V_DATE "+%Y-%m"`
V_TODAYMONTHDATESTART="$V_TODAYMONTH-01"
V_LASTMONTHDATESTART=`date --date="$V_TODAYMONTHDATESTART-1 month" +%Y-%m-%d`
V_LASTMONTHDATEEND=`date --date="$V_TODAYMONTHDATESTART-1 day" +%Y-%m-%d`
V_LASTYEAR=`date -d $V_LASTMONTHDATEEND "+%Y"`
V_LASTMONTH=`date -d $V_LASTMONTHDATEEND "+%m"`
V_LASTDAY=`date -d $V_LASTMONTHDATEEND "+%d"`

#today,yesterday,7 day  ago,30 days ago,2 days ago  date
V_TODAY=`date -d $V_DATE "+%Y-%m-%d"`
V_TODAY_YEAR=`date --date="$V_TODAY day" +%Y`
V_TODAY_MONTH=`date --date="$V_TODAY day" +%m`
V_TODAY_DAY=`date --date="$V_TODAY day" +%d`
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

echo "V_DATE=$V_DATE"
echo "V_LASTMONTHDATESTART=$V_LASTMONTHDATESTART"
echo "V_LASTMONTHDATEEND=$V_LASTMONTHDATEEND"
echo "V_LASTYEAR=$V_LASTYEAR V_LASTMONTH=$V_LASTMONTH V_LASTDAY=$V_LASTDAY"

/home/xiaoju/hive-0.10.0/bin/hive -e"use app;
set hive.optimize.cp=true;
set hive.map.aggr=true;
set hive.groupby.mapaggr.checkinterval = 100000;
set hive.exec.parallel=true;
INSERT OVERWRITE TABLE driveractivedata PARTITION(YEAR='$V_LASTYEAR',MONTH='$V_LASTMONTH')
select 
			0,'$V_LASTYEAR-$V_LASTMONTH-01',
			O.area ,newdrivercnt,totaldrivercnt,monthstrivedrivercnt,monthstrivesuccdrivercnt,monthstrivesuccavgcnt,
			(case when monthtotolonlinecnt is null then 0 else cast(monthtotolonlinecnt as int) end) as monthtotolonlinecnt,
			(case when monthtotalonlinetime is null then 0 else cast(monthtotalonlinetime as int) end) as monthtotalonlinetime,
		  (case when monthavgonlimetime is null then 0 else monthavgonlimetime end) as monthavgonlimetime,
		  (case when avgdaydriveronlinecnt is null then 0 else cast(avgdaydriveronlinecnt as int) end) as avgdaydriveronlinecnt,
			(case when avgdaydriveronlinerate is null then 0.00 else avgdaydriveronlinerate end) as avgdaydriveronlinerate,
		  (case when avgdaystrivedrivercnt is null then 0 else cast(avgdaystrivedrivercnt as int) end) as avgdaystrivedrivercnt,
		  (case when avgdaystrivesuccdrivercnt is null then 0 else cast(avgdaystrivesuccdrivercnt as int) end) as avgdaystrivesuccdrivercnt,
			(case when avgdayonlinestrivesuccrate is null then 0.00 else avgdayonlinestrivesuccrate end) as avgdayonlinestrivesuccrate
from
(
	select 	(CASE WHEN area IS NULL THEN 10000 ELSE CAST(area AS INT) END) area,
					newdrivercnt,
					totaldrivercnt
	from
	(
		select 
		area,
		count(distinct (case when regdate >='$V_LASTMONTHDATESTART' and regdate <='$V_LASTMONTHDATEEND' and checkdate >='$V_LASTMONTHDATESTART' and checkdate <='$V_LASTMONTHDATEEND' and activedate >='$V_LASTMONTHDATESTART' and activedate <='$V_LASTMONTHDATEEND' then driverid  else 0 end )) -1 as newdrivercnt ,
	  count(distinct (case when regdate is not null and checkdate is not null and activedate is not null then driverid else 0 end ))-1  as totaldrivercnt
		from	pdw.driver 
		where channel !=1 and year='$V_LASTYEAR' and month='$V_LASTMONTH' and day='$V_LASTDAY'
		group by area 
		GROUPING SETS(area,())
	) A
) O
LEFT OUTER JOIN
(
	select (CASE WHEN area IS NULL THEN 10000 ELSE CAST(area AS INT) END) area,
				strivedrivercnt as monthstrivedrivercnt,
				strivesuccdrivercnt as monthstrivesuccdrivercnt,
				(case when strivesuccdrivercnt !=0 then cast(round(totalsuccordercnt/strivesuccdrivercnt,0) as int) else 0 end) as monthstrivesuccavgcnt
	from
	(select 
	 area,
	 count(distinct (case when driverid > 0 then driverid else 0 end))-1 as strivedrivercnt,
	 count(distinct (case when (status >=1 and status <=3 or (status =4 and driverid > 0)) then driverid else 0 end))-1 as strivesuccdrivercnt,
	 count(distinct (case when (status >=1 and status <=3 or (status =4 and driverid > 0)) then orderid else cast(0 as bigint) end))-1 as totalsuccordercnt
	from 
	    (select  orderid,driverid,area,status from pdw.dw_order where year='$V_LASTYEAR' and month='$V_LASTMONTH') B
	group by area 
	GROUPING SETS(area,())
    ) A
) P
ON O.area = P.area
LEFT OUTER JOIN
(
	select 	(CASE WHEN area IS NULL THEN 10000 ELSE CAST(area AS INT) END) area,
					 monthtotolonlinecnt,
					 monthtotalonlinetime,
					(case when monthtotolonlinecnt =0 then  cast(round(monthtotalonlinetime/monthtotolonlinecnt , 0) as int) else 0 end) as monthavgonlimetime
					from(
	select      area,
				count(distinct did) as monthtotolonlinecnt,
				sum(onlinetime) as monthtotalonlinetime
	from pdw.op_staticstic_driver
	where year='$V_LASTYEAR' and month='$V_LASTMONTH' and onlinetime>0
	group by area
	GROUPING SETS(area,())
	) A
) Q
ON O.area = Q.area
LEFT OUTER JOIN
(
	select 
	area,
	round(avg(daydriveronlinecnt),0) as avgdaydriveronlinecnt,
	round(avg(daydriveronlinecnt/activedrivercnt),3) as avgdaydriveronlinerate,
	round(avg(strivedrivercnt),0) as avgdaystrivedrivercnt,
  round(avg(strivesuccdrivercnt),0) as avgdaystrivesuccdrivercnt,
  round(avg(onlinestrivesuccrate),3) as avgdayonlinestrivesuccrate
from
(
	select 
		U.createdate,
	  U.area,
	  daydriveronlinecnt,
	  (case when activedrivercnt is null then 0 else activedrivercnt end) as activedrivercnt,
		(case when strivedrivercnt is null then 0 else cast(strivedrivercnt as int) end) as strivedrivercnt,
	  (case when strivesuccdrivercnt is null then 0 else cast(strivesuccdrivercnt as int) end) as strivesuccdrivercnt,
	  round(strivesuccdrivercnt/daydriveronlinecnt,3) as onlinestrivesuccrate
	from
	(
			select op_staticstic_driver_date as createdate,area,daydriveronlinecnt
			from
			(
				select op_staticstic_driver_date, area,	count(distinct did) as daydriveronlinecnt 
				from pdw.op_staticstic_driver 
				where year='$V_LASTYEAR' and month='$V_LASTMONTH' and onlinetime>0 
				group by op_staticstic_driver_date,area 
			 	UNION ALL
				select op_staticstic_driver_date,'10000' as area,	count(distinct did) as daydriveronlinecnt
				from pdw.op_staticstic_driver 
			 	where year='$V_LASTYEAR' and month='$V_LASTMONTH' and onlinetime>0 
				group by op_staticstic_driver_date 
			) A
	) U
	LEFT OUTER JOIN
	(
		select createdate,area,activedrivercnt
		from
		pdw.activedriver_day 
		where year='$V_LASTYEAR' and month='$V_LASTMONTH' 
	) V
	ON  U.createdate = V.createdate and U.area = V.area 
	LEFT OUTER JOIN
	(
		 select createdate,area,strivedrivercnt,strivesuccdrivercnt
		 from
		 (
			select A.createdate,A.area,
			 count(distinct (case when driverid > 0 then driverid else 0 end))-1 as strivedrivercnt,
			 count(distinct (case when (status >=1 and status <=3 or (status =4 and driverid > 0)) then driverid else 0 end))-1 as strivesuccdrivercnt
			from 
			(select driverid,substr(createtime,0,10) as createdate,area,status from pdw.dw_order where year='$V_LASTYEAR' and month='$V_LASTMONTH') A
				group by A.createdate,A.area 
			 UNION ALL
			select B.createdate,'10000' as area,
			 count(distinct (case when driverid > 0 then driverid else 0 end))-1 as strivedrivercnt,
			 count(distinct (case when (status >=1 and status <=3 or (status =4 and driverid > 0)) then driverid else 0 end))-1 as strivesuccdrivercnt
			from 
			(select  driverid,substr(createtime,0,10) as createdate,status from pdw.dw_order where year='$V_LASTYEAR' and month='$V_LASTMONTH') B
				group by B.createdate
		 ) B
	) W
	ON U.createdate = W.createdate and U.area = W.area
) daytable 
group by area 
) R
ON O.area = R.area
;"
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/driveractivedata/$V_LASTYEAR/$V_LASTMONTH/_SUCCESS
