#!/bin/sh

cwd=`readlink -f $0`
cd `dirname $cwd`

clspath=".:jutil-1.0.2.jar"
STORM_HOME="/data/xiaoju/apache-storm-0.9.1-incubating"
for f in `ls $STORM_HOME/lib/*.jar`; do
	export clspath=${clspath}:$f;
done

if [ $# -eq 0 ];then
    java -Xms1024m -Xmx1024m -XX:MaxPermSize=256m -classpath "${clspath}" xiaoju.platform.storm.examples.StormClient
    exit
fi

if [[ $1 = "StormClient.java" ]];then
    javac -d . -classpath "${clspath}" $1
    exit
fi

java -Xms1024m -Xmx1024m -XX:MaxPermSize=256m -classpath "${clspath}" xiaoju.platform.storm.examples.StormClient $*
#java -classpath "${clspath}" org.apache.hadoop.mapred.HdpJobClient
