#!/bin/sh

hdpbin=$HADOOP_HOME
nslist=`${hdpbin%%/}/bin/hdfs getconf -confKey dfs.nameservices`
for ns in `echo $nslist | sed 's/,/ /g'`; do
    nns=`${hdpbin%%/}/bin/hdfs getconf -confKey dfs.ha.namenodes.$ns`
    for n in `echo $nns | sed 's/,/ /g'` ;do
    	nnhost=`${hdpbin%%/}/bin/hdfs getconf -confKey dfs.namenode.rpc-address.${ns}.${n}`
	state=`${hdpbin%%/}/bin/hdfs haadmin -getServiceState $n`
	topomap="$ns|$n|${nnhost%%:*}|$state\n"${topomap}
	echo $nnhost | grep `hostname -s` >/dev/null
        if [ $? -eq 0 ]; then
                flg=1
        fi
    done
    if [ $flg -eq 1 ];then
        localNameService=$ns
	break
    fi
done

clear
echo 读取配置完成!!!
activeHost=`echo -e $topomap | grep active | awk -F "|" '{print $3}'`
standbyHost=`echo -e $topomap | grep standby | awk -F "|" '{print $3}'`
standbyNN=`echo -e $topomap | grep standby | awk -F "|" '{print $2}'`

# kill active namenode
pid=`ssh $activeHost "jps -ml | grep NameNode" | awk '{print $1}'`
echo "kill Active NameNode PID:"$pid
ssh $activeHost kill $pid

echo "Wait standby ==> active"
while true;do
    sleep 3

    state=`${hdpbin%%/}/bin/hdfs haadmin -getServiceState ${standbyNN}`
    if [ $state = "active" ]; then
	break
    fi
done

# standby -> active SUCCESS ;then kill local nnpid
echo Standby To Active SUCCESS!!!
echo .
echo .
echo .
echo 启动原 Active NameNode
ssh $activeHost "${hdpbin%%/}/sbin/hadoop-daemon.sh start namenode"

echo 等待standby离开安全模式
while true;do
    sleep 3

    state=`ssh $standbyHost "${hdpbin%%/}/bin/hdfs dfsadmin -safemode get"`
    state=`echo $state|awk '{print $4}'`
    if [ $state = "OFF" ]; then
	break
    fi

    # 等待 远程事件结束
done

echo 等待active离开安全模式
while true;do
    sleep 3

    state=`ssh $activeHost "${hdpbin%%/}/bin/hdfs dfsadmin -safemode get"`
    state=`echo $state|awk '{print $4}'`
    if [ $state = "OFF" ]; then
	break
    fi
done

# Active namenode启动成功；then reboot Standby namenode
pid=`ssh $standbyHost "jps -ml | grep NameNode " |awk '{print $1}'`
echo 重启 Standby namenode,使Active NameNode 切换为active
ssh $standbyHost kill $pid
sleep 2
ssh $standbyHost ${hdpbin%%/}/sbin/hadoop-daemon.sh start namenode
