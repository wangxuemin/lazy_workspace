#!/bin/sh

IMAGE="cluster"
START="/etc/init.d/ssh start -D"

function gethostip()
{
	sudo docker inspect -f '{{.NetworkSettings.IPAddress}}' $1
}

function gethostspath()
{
	sudo docker inspect -f '{{.HostsPath}}' $1
}

#echo `gethostip node00`
#echo `gethostspath node00`
sudo docker run -d --hostname="node00" --name="node00" -t ${IMAGE}.node00 ${START}
sudo docker run -d --hostname="node01" --name="node01" -t ${IMAGE}.node01 ${START}
sudo docker run -d --hostname="node02" --name="node02" -t ${IMAGE}.node02 ${START}
sudo docker run -d --hostname="node03" --name="node03" -t ${IMAGE}.node03 ${START}
sudo docker run -d --hostname="node04" --name="node04" -t ${IMAGE}.node04 ${START}
sudo docker run -d --hostname="node05" --name="node05" -t ${IMAGE}.node05 ${START}
sudo docker run -d --hostname="node06" --name="node06" -t ${IMAGE}.node06 ${START}
#sudo docker run -d --hostname="node07" --name="node07" -t ${IMAGE}.node07 ${START}
#sudo docker run -d --hostname="node08" --name="node08" -t ${IMAGE}.node08 ${START}
#sudo docker run -d --hostname="node09" --name="node09" -t ${IMAGE}.node09 ${START}

# 获取 container ip
sudo echo `gethostip node00` node00 > hosts.tmp
sudo echo `gethostip node01` node01 >> hosts.tmp
sudo echo `gethostip node02` node02 >> hosts.tmp
sudo echo `gethostip node03` node03 >> hosts.tmp
sudo echo `gethostip node04` node04 >> hosts.tmp
sudo echo `gethostip node05` node05 >> hosts.tmp
sudo echo `gethostip node06` node06 >> hosts.tmp
#sudo echo `gethostip node07` node07 >> hosts.tmp
#sudo echo `gethostip node08` node08 >> hosts.tmp
#sudo echo `gethostip node09` node09 >> hosts.tmp

# 分发 hosts
sudo cp hosts.tmp `gethostspath node00` 
sudo cp hosts.tmp `gethostspath node01`
sudo cp hosts.tmp `gethostspath node02`
sudo cp hosts.tmp `gethostspath node03`
sudo cp hosts.tmp `gethostspath node04`
sudo cp hosts.tmp `gethostspath node05`
sudo cp hosts.tmp `gethostspath node06`
#sudo cp hosts.tmp `gethostspath node07`
#sudo cp hosts.tmp `gethostspath node08`
#sudo cp hosts.tmp `gethostspath node09`

sudo chmod 666 /etc/hosts
sudo chmod 666 /etc/hosts.bak
sudo touch /etc/hosts.tmp
sudo chmod 666 /etc/hosts.tmp

sudo cp /etc/hosts /etc/hosts.bak
sudo grep -v "node" /etc/hosts.bak > /etc/hosts.tmp
sudo cat hosts.tmp >> /etc/hosts.tmp
sudo mv /etc/hosts.tmp /etc/hosts
