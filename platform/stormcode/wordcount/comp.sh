#!/bin/sh

STORM=${STORM:-~/storm-0.9.0.1}

clspath=${STORM}/storm-core-0.9.0.1.jar:resources/jedis-2.1.0.jar

KAFKA_HOME="/home/xiaoju/kafka_2.9.2-0.8.1"
for f in `ls $KAFKA_HOME/libs/*.jar`; do
            clspath=${clspath}:$f;
done

javac -d . -classpath ${clspath} *.java
jar cmvf META-INF/MANIFEST.MF storm-example.jar xiaoju/ resources/
