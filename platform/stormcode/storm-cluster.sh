#!/bin/sh

usage="Usage: `basename $0` (start|stop) (nimbus|supervisor)"

if [ $# -lt 2 ]; then
    echo $usage
    exit
fi

if [ -z $STORM_HOME ]; then
    echo "STORM_HOME is not set!"
    exit
fi

while [ $# -gt 0 ]; do
  case "$1" in
    start|stop)
      startStop=$1
      shift
      command=$1
          case "$command" in
            nimbus|supervisor)
            ;;
            *)
              echo $usage
              exit
            ;;
          esac
      shift
      ;;
    help)
      echo $usage
      exit
      ;;
    *)
      break
      ;;
  esac
done

slaves="hdp72.qq hdp73.qq hdp74.qq hdp75.qq hdp76.qq"

case $command in
    (nimbus)
       sh storm-daemon.sh $startStop $command
       sh storm-daemon.sh $startStop ui
    ;;

    (supervisor)
    for slave in $slaves; do 
       ssh $slave sh ~/lihan/storm-daemon.sh $startStop $command
    done

    ;;

    (*)
    
    ;;
esac
