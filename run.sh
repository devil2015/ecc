#!/bin/bash

PWD=`pwd`
LOG=${PWD}/log
mkdir -p ${LOG}

start()
{
	daemonize -c $PWD/doc -e ${LOG}/ipython_error.log -o ${LOG}/ipython.log -l ${LOG}/ipython.loc -p ${LOG}/ipython.pid -v ${PWD}/helper/ipython.sh 
}
stop()
{
	IPYTHON_PID=`cat ${LOG}/ipython.pid` # | xargs kill -9
	CPIDS=$(pgrep -P ${IPYTHON_PID}); (sleep 33 && kill -KILL $CPIDS &); kill -TERM $CPIDS
	rm -rf ${LOG}/git.loc ${LOG}/ipython.loc ${LOG}/gource.loc
}

case "$1" in
    start )
        echo "starting ............."
	start
        echo "...............started" ;;
    stop )
        echo "stoping .............." 
	stop
        echo "................stoped" ;;
    restart )
        echo "restarting ..........."
	stop
	sleep 1
	start
        echo "...............started" ;;
    * )
        echo "usage $0 (start|stop|restart)"
        echo "let me restart it for you.... :)"
        echo "restarting ..........."
	stop
	start
        echo "...............started" ;;
esac
