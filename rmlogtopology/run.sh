#!/bin/sh

if [ "x$1" = "xkill" ];then
    storm kill RMLogTopology
    exit 1
fi
storm jar storm_resourcemanager.jar xiaoju.platform.storm.examples.RMLogTopologyMain $*
