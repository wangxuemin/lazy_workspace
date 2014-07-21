#!/bin/sh
if [ $# -eq 1 ];then
   nowdate=$1
else
  nowdate=`date --date "-1 day" "+%Y/%m/%d"`
fi
 echo $nowdate
 predate=`date --date "${nowdate} -1 day" "+%Y/%m/%d"`
 echo $predate
HADOOP_HOME=/home/xiaoju/hadoop-1.0.4  
y=${nowdate:0:(4)}
mon=${nowdate:5:(2)}
day=${nowdate:8:(2)}  
y1=${predate:0:(4)}
mon1=${predate:5:(2)}
day1=${predate:8:(2)}
/home/xiaoju/hive-0.10.0/bin/hive -e "create temporary function e2string as 'com.diditaxi.util.hiveudf.E2StringUDF1';
INSERT OVERWRITE TABLE app.wx_money_data partition(year='$y',month='$mon',day='$day') select '0',
			'$y-$mon-$day', 
			c.area,
			'0',
			c.cash_people_num,
			c.cash_people_num_succ,
			e2string(c.cash_total/100),
			e2string(c.cash_total_succ/100),
			c.cash_num,
			c.cash_num_succ,
			round(c.cash_num_succ/c.cash_people_num_succ,2),
			round(c.cash_total_succ/c.cash_people_num_succ/100,2),
			e2string(c1.wepay_web_succ_cost/100),
			e2string(c1.wepay_app_succ_cost/100),
			e2string((c1.wepay_web_succ_cost+c1.wepay_app_succ_cost)/100),
			e2string(c2.wepay_web_succ_cost/100),
			e2string(c2.wepay_app_succ_cost/100),
			e2string((c2.wepay_web_succ_cost+c2.wepay_app_succ_cost)/100),
			c3.driver_num,
			e2string(c3.driver_money/100),
			c6.total_p_num,
			e2string(c6.total_p_cost/100),
			c4.driver_num,
			e2string(c4.driver_money/100),
			c5.total_p_num,
			e2string(c5.total_p_cost/100),
			e2string(c6.all_cut_total_cost/100),
			c6.all_cut_total,
			c6.all_cut_total_passenger,
			c6.all_cut_below_20,
			case when c6.all_cut_total='0' or c6.all_cut_total='' then 0.00 else c6.all_cut_below_20/c6.all_cut_total end,
			e2string(c6.all_cut_below_20_cost/100),
			c6.all_cut_below_50,
			case when c6.all_cut_total='0' or c6.all_cut_total='' then 0.00 else c6.all_cut_below_50/c6.all_cut_total end,
			e2string(c6.all_cut_below_50_cost/100),
			c6.all_cut_below_100,
			case when c6.all_cut_total='0' or c6.all_cut_total='' then 0.00 else c6.all_cut_below_100/c6.all_cut_total end,
			e2string(c6.all_cut_below_100_cost/100),
			c6.all_cut_above_100,
			case when c6.all_cut_total='0' or c6.all_cut_total='' then 0.00 else c6.all_cut_above_100/c6.all_cut_total end,
			e2string(c6.all_cut_above_100_cost/100)
 from
(select case when b.area='' or b.area is null then '10000' else b.area end as area,
		count(distinct a.driverid) as cash_people_num,
		count(distinct (case when a.status='1' then a.driverid else 0 end)) as cash_people_num_succ,
		sum(a.amount) as cash_total,
		sum(case when a.status='1' then a.amount else 0 end) as cash_total_succ,
		count(*) as cash_num,
		sum(case when a.status='1' then 1 else 0 end) as cash_num_succ
		from (select driverid,status,amount from pdw.wx_driver_transaction where year='$y' and month='$mon' and day='$day' and trans_type=-1 and trans_sub_type like '提现%') a
		join 
		(select area,driverid from pdw.driver  where year='$y' and month='$mon' and day='$day')  b 
		on a.driverid=b.driverid
		group by b.area
grouping sets (b.area,())) c
join 
(select case when b1.area='' or b1.area is null then '10000' else b1.area end as area,
		sum(case when b1.channel='1200' then a1.cost else 0 end) as wepay_web_succ_cost,
		sum(case when b1.channel!='1200' then a1.cost else 0 end) as wepay_app_succ_cost
		from
    (select orderid,cost from pdw.wx_didi_transaction  where year='$y' and month='$mon' and day='$day' and status='1') a1
		join
		(select orderId,channel,area from pdw.dw_order) b1
		on a1.orderid=b1.orderid
		group by b1.area
		grouping sets (b1.area,())) c1
		on c.area=c1.area 
join 
(select case when b2.area='' or b2.area is null then '10000' else b2.area end as area,
		sum(case when b2.channel='1200' then a2.cost else 0 end) as wepay_web_succ_cost,
		sum(case when b2.channel!='1200' then a2.cost else 0 end) as wepay_app_succ_cost
		from
    (select orderid,cost from pdw.wx_didi_transaction  where status='1') a2
		join
		(select orderId,channel,area from pdw.dw_order ) b2
		on a2.orderid=b2.orderid
		group by b2.area
		grouping sets (b2.area,())) c2
		on c1.area=c2.area 
join 
(select case when b3.area='' or b3.area is null then '10000' else b3.area end as area,
		count(distinct a3.driverid) as driver_num,
		sum(a3.amount) as driver_money
		from (select driverid,amount
		from  pdw.wx_driver_transaction 
		where status = 1 and year='$y' and month='$mon' and day='$day'
	  and partner_type = 2 and trans_sub_type = '支付奖励') a3 
	  join 
		(select area,driverid from pdw.driver  where year='$y' and month='$mon' and day='$day')  b3 
		on a3.driverid=b3.driverid
		group by b3.area
grouping sets (b3.area,())) c3
on c2.area=c3.area 
join 
(select case when b4.area='' or b4.area is null then '10000' else b4.area end as area,
		count(distinct a4.driverid) as driver_num,
		sum(a4.amount) as driver_money
		from (select driverid,amount
		from  pdw.wx_driver_transaction 
		where status = 1 
	  and partner_type = 2 and trans_sub_type = '支付奖励') a4
	  join 
		(select area,driverid from pdw.driver  where year='$y' and month='$mon' and day='$day')  b4 
		on a4.driverid=b4.driverid
		group by b4.area
grouping sets (b4.area,())) c4
on c3.area=c4.area 
join 
(select case when b6.area='' or b6.area is null then '10000' else b6.area end as area,
		count(distinct (case when a6.couponid>=2 and a6.couponid<100  then a6.passengerid else 0 end)) as total_p_num,
		sum(case when a6.couponid>=2 and a6.couponid<100  then a6.less_money else 0 end) as total_p_cost
		from 
		(select orderid, driverid, passengerid, 
				cost, (cost - total_fee) as less_money,couponid
				from  
				pdw.wx_didi_transaction 
				where 
				status = 1  and partner_type = 1 and trans_type = 1) a6
				join
		(select orderId,area from pdw.dw_order) b6
	on a6.orderid=b6.orderid
	group by b6.area
	grouping sets (b6.area,())) c5
	on c4.area=c5.area 
join 
(select case when b5.area='' or b5.area is null then '10000' else b5.area end as area,
		count(distinct (case when a5.couponid>=2 and a5.couponid<100  then a5.passengerid else 0 end)) as total_p_num,
		sum(case when a5.couponid>=2 and a5.couponid<100  then a5.less_money else 0 end) as total_p_cost,
		sum(case when a5.couponid='100' then 1 else 0 end) as all_cut_total,
		sum(case when a5.couponid='100' then a5.less_money else 0 end) as all_cut_total_cost,
		count(distinct (case when a5.couponid='100' then a5.passengerid else 0 end)) as all_cut_total_passenger,
		sum(case when a5.couponid='100' and a5.cost<=2000 then 1 else 0 end) as all_cut_below_20,
		sum(case when a5.couponid='100' and a5.cost<=2000 then a5.less_money else 0 end) as all_cut_below_20_cost,
		sum(case when a5.couponid='100' and a5.cost>2000 and a5.cost<=5000 then 1 else 0 end) as all_cut_below_50,
		sum(case when a5.couponid='100' and a5.cost>2000 and a5.cost<=5000 then a5.less_money else 0 end) as all_cut_below_50_cost,
		sum(case when a5.couponid='100' and a5.cost>5000 and a5.cost<=10000 then 1 else 0 end) as all_cut_below_100,
		sum(case when a5.couponid='100' and a5.cost>5000 and a5.cost<=10000 then a5.less_money else 0 end) as all_cut_below_100_cost,
		sum(case when a5.couponid='100' and a5.cost>10000  then 1 else 0 end) as all_cut_above_100,
		sum(case when a5.couponid='100' and a5.cost>10000 then a5.less_money else 0 end) as all_cut_above_100_cost
		from 
		(select orderid, driverid, passengerid, 
				cost, (cost - total_fee) as less_money,couponid
				from  
				pdw.wx_didi_transaction 
				where 
				status = 1  and partner_type = 1 and trans_type = 1 and year='$y' and month='$mon' and day='$day') a5
				join
		(select orderId,area from pdw.dw_order) b5
		on a5.orderid=b5.orderid
		group by b5.area
		grouping sets (b5.area,())) c6
		on c5.area=c6.area"
		
/home/xiaoju/hadoop-1.0.4/bin/hadoop fs -touchz /user/xiaoju/data/bi/app/wx_money_data/$nowdate/_SUCCESS
		
		
