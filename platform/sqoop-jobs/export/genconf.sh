#!/bin/sh

#/home/xiaoju/sqoop-export/bin/sqoop export --connect 'jdbc:mysql://hdp998.jx:3377/data_mart?zeroDateTimeBehavior=convertToNull' --username app_w --password app_w --table DriverRegOnline --columns 'statDate,area,channel,dayNatureRegOnlineCnt,weekNatureRegOnlineCnt,monthNatureRegOnlineCnt,dayNatureReg6HoursOnlineCnt,dayNatureRegNotOnlineCnt,weekNatureRegOnlineRate,monthNatureRegOnlineRate' --fields-terminated-by '\001' --export-dir /user/xiaoju/data/bi/app/driverregonline/2014/01/09
if [ ! -e mart_create_table.sql ];then
    echo Conot find file mart_create_table.sql
    exit
fi
day=`date +%Y-%m-%d`
mkdir -p etc
mv etc/sqoop-export-table.conf etc/sqoop-export-table.${day}.conf

egrep -v "USE|DROP|KEY|ENGINE|^/|^--" mart_create_table.sql |tr -s '\n' | awk 'BEGIN{
    r_table ="^CREATE TABLE `([_0-9A-Za-z]*)`";
    r_column="^[ \t]*`([_0-9A-Za-z]*)`";
    
}{
    if( match( $0, r_table , restable ))
    {
        table=restable[1];
    }else if( match( $0, r_column, rescol ))
    {
        if( table_column_map[table] == "" )
        {
            if( rescol[1] != "statId" )
            {
                table_column_map[table]=rescol[1];
            }
        }else{
            table_column_map[table]=table_column_map[table]","rescol[1];
        }
    }
}END{
    for ( iter in table_column_map )
    {
        print iter":"table_column_map[iter];
    }
}' | egrep -v "DataMartIndex|BIOrderBonus|finance_report" | tee etc/sqoop-export-table.conf
