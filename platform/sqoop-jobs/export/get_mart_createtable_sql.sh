#!/bin/sh

/home/xiaoju/mysql-client/bin/mysqldump -h0.jx -u -p -P7 --database --no-data ${dbname} > mart_create_table.sql
