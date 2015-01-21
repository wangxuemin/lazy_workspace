#!/bin/sh

for((i=0;i<7;i++)) do 
	sudo docker commit node0${i} cluster.node0${i}
done

sudo docker kill $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)
