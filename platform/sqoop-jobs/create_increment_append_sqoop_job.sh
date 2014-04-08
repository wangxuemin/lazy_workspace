#!/bin/sh

mysql_username=app_r
mysql_password=app_r
jdbcURI=jdbc:mysql://10.10.10.122:3306/app_dididache?zeroDateTimeBehavior=convertToNull

table_incremental="stat_preorder:oid"

for tableinfo in ${table_incremental};do
    table=${tableinfo%%:*}
    incid=${tableinfo##*:}

    sqoop job --create ${table}_sqoop_job -- import --connect "${jdbcURI}" --table ${table} --username ${mysql_username} --password ${mysql_password} -m 1 --fields-terminated-by '\001' --incremental append --check-column ${incid} --null-string '' --null-non-string '' --as-textfile

done
