#!/bin/sh

begdate='2014-02-21'
enddate='2014-02-23'
tablename='passengerregandcall driverreg todaydriver6houronline_dprate driverretentionrates'

rm `basename $0`.log
for(( i=0; ; i++ ));do
        
        if [[ ${day} = ${enddate} ]];then
            break;
        fi

        day=`date +%Y-%m-%d -d "+${i}days ${begdate}"`
#       echo ${day}
        for t in ${tablename};do
             sh sqoop-export.sh -table ${t} -date ${day} >>`basename $0`.log 2>&1
#            echo sh sqoop-export.sh -table ${t} -date ${day}
        done
done
