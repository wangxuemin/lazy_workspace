create table uaat(
keyname string,
keytime string,
tmstamp timestamp,
dttime string,
mac string,
phone string,
platform int,
usertype int,
channel int
)partitioned by( stat_date string ) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
