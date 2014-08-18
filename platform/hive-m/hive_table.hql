CREATE EXTERNAL TABLE city(
        cityid int, 
        cityname string, 
        municipalityarea double, 
        urbanarea double, 
        ruralarea double, 
        lngmin double, 
        lngmax double, 
        latmin double, 
        latmax double)
PARTITIONED BY ( 
        year string, 
        month string, 
        day string)
ROW FORMAT SERDE 
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
STORED AS INPUTFORMAT 
'org.autonavi.udf.CustomInputFormat' 
OUTPUTFORMAT 
'org.autonavi.udf.CustomHiveOutputFormat'
