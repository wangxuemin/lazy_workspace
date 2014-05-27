#!/bin/sh

hdpbin=$HADOOP_HOME
nnlist=`${hdpbin%%/}/bin/hdfs getconf -namenodes`

localmachine=`hostname -s`

for nn in $nnlist ;do
	echo $nn | grep $localmachine >/dev/null
	if [ $? -eq 0 ]; then
		continue
	else
		remotmachine=$nn" "$remotmachine
	fi
done

for remotnn in $remotmachine ;do
	remotnnpid=`ssh $remotnn "jps -ml | grep NameNode " |awk '{print $1}'`
	break;
done
#echo "Remot NameNode PID:"$remotnnpid

# kill local namenode
nnpid=`jps -ml | grep NameNode | awk '{print $1}'`
echo "kill Local NameNode PID:"$nnpid
kill $nnpid

echo "Wait standby ==> active"
while true;do
    sleep 3

    state=`${hdpbin%%/}/bin/hdfs haadmin -getServiceState nn2`
    if [ $state = "active" ]; then
	break
    fi
done

# standby -> active SUCCESS ;then kill local nnpid
echo standby To active SUCCESS!!!
echo 启动本地namenode
${hdpbin%%/}/sbin/hadoop-daemon.sh start namenode

echo 等待remote离开安全模式
while true;do
    sleep 3

    state=`ssh $remotnn ${hdpbin%%/}/bin/hdfs dfsadmin -safemode get`
    state=`echo $state|awk '{print $4}'`
    if [ $state = "OFF" ]; then
	break
    fi

    # 等待 远程事件结束
done

echo 等待local离开安全模式
while true;do
    sleep 3

    state=`${hdpbin%%/}/bin/hdfs dfsadmin -safemode get`
    state=`echo $state|awk '{print $4}'`
    if [ $state = "OFF" ]; then
	break
    fi
done

# 本地namenode启动成功；then reboot remote namenode
echo 重启远程namenode,使Local NameNode 切换为active
ssh $remotnn kill $remotnnpid
sleep 2
ssh $remotnn ${hdpbin%%/}/sbin/hadoop-daemon.sh start namenode
