#!/bin/sh

/home/xiaoju/mysql-client/bin/mysqldump -hstg0.jx -uguanxingtai -pshuxingxing -P3377 --database --no-data data > stgdata_create_table.sql
