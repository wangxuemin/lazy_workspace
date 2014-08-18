#!/bin/sh

usage="Usage: `basename $0` (start|stop) (ui|nimbus|supervisor)"
STORM_HOME="/data/xiaoju/apache-storm-0.9.1-incubating"

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
            ui|nimbus|supervisor)
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

STORM_PID_DIR=${STORM_PID_DIR:-$STORM_HOME/pid}
STORM_LOG_DIR=${STORM_LOG_DIR:-$STORM_HOME/logs}

pid=$STORM_PID_DIR/storm-$command.pid
log=$STORM_LOG_DIR/storm-$command.out

case $startStop in
    (start)

      [ -w "$STORM_PID_DIR" ] ||  mkdir -p "$STORM_PID_DIR"
      if [ -f $pid ]; then
        if kill -0 `cat $pid` > /dev/null 2>&1; then
          echo $command running as process `cat $pid`.  Stop it first.
          exit 1
        fi
      fi
      echo "`hostname` start $command logging to: $log"
      nohup nice python $STORM_HOME/bin/storm $command > "$log" 2>&1 < /dev/null &
      echo $! > $pid
      
      ;;
    
    (stop)

      if [ -f $pid ]; then
        TARGET_PID=`cat $pid`
        if kill -0 $TARGET_PID > /dev/null 2>&1; then
          echo "`hostname` stopping $command"
          kill $TARGET_PID
          sleep 1
          if kill -0 $TARGET_PID > /dev/null 2>&1; then
            echo "$command did not stop gracefully after 1 seconds: killing with kill -9"
            kill -9 $TARGET_PID
          fi
        else
          echo no $command to stop
        fi
      else
        echo no $command to stop
      fi
      ;;

    (*)
      echo $usage
      exit 1
      ;;

esac
