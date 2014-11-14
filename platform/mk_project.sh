#!/bin/sh

find ../hadoop-2.2.0-src-container-executor/ -name *.java | xargs grep ^package | awk -F ":" '{print $1, $2}' | while read line; do
    srcfile=`echo $line|awk '{print $1}'`
    package=`echo $line|awk '{print $3}'`

    dst=`echo $package|sed -e 's/\./\//g' -e 's/;//g'`
    mkdir -p $dst

    cp $srcfile $dst

done
