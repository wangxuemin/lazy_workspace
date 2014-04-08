#!/bin/sh

begdate='2013-12-23'
enddate='2014-02-08'

for(( i=0; ; i++ ));do
        
        if [[ ${day} = ${enddate} ]];then
            break;
        fi

        day=`date +%Y-%m-%d -d "+${i}days ${begdate}"`
#        echo ${day}
        sh order_sqoop_import.bak.sh ${day} >runlog 2>&1 
done
