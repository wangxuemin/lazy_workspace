#!/bin/sh

############# SQOOP ############
export SQOOP="/data/xiaoju/sqoop-1.4.4_hadoop-0.23/bin/sqoop"
export SQOOP_COMMON_OPTS="--direct"

############# GULFSTREAM ####### 
#export GULFSTREAM_COMPRESS_OPTS="--as-textfile --compression-codec \"com.hadoop.compression.lzo.LzoCodec\""
export GULFSTREAM_COMPRESS_OPTS="--as-textfile"
export GULFSTREAM_COMMON_PATH=
