#!/bin/bash

# chkconfig:   2345 90 10
# description:  Redis is a persistent key-value database
# setup sudo chown ubuntu  /etc/init.d/redis  
# sudo ./runredis.sh setup
# sudo update-rc.d redis_6379 start 20 2 3 4 5 . stop 20 0 1 6 .
# sudo update-rc.d -f redis_6379 remove
# sudo systemctl start redis_6379
# sudo systemctl stop redis_6379
# systemctl status redis_6379.service
# systemctl restart redis_6379.service


###############
# SysV Init Information
# chkconfig: - 58 74
# description: redis_ is the redis daemon.
### BEGIN INIT INFO
# Provides: redis_6379
# Required-Start: $network $local_fs $remote_fs
# Required-Stop: $network $local_fs $remote_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Should-Start: $syslog $named
# Should-Stop: $syslog $named
# Short-Description: start and stop redis_6379
# Description: Redis daemon
### END INIT INFO
#/usr/local/redis/bin/redis-server /etc/systemd/system/redis_6379.service

REDISPORT=6379  
PATH=/usr/local/redis/bin/:/usr/local/redis/:/usr/sbin/:/usr/local/bin:/sbin:/usr/bin:/bin   

PIDFILE=/var/run/redis/redis_$REDISPORT.pid   
#SERVICECONF=/etc/systemd/system/redis_$REDISPORT.service
SETUPDIR=/usr/local 
EXEC=$SETUPDIR/bin/redis-server  
REDIS_CLI=$SETUPDIR/bin/redis-cli
CONF=$SETUPDIR/redis_$REDISPORT.conf
 
AUTH="1234"  

case "$1" in 
        show)
        
                if   echo "$2" |sed 's/\.\|-\|+\|%\|\^//g'  | grep [^0-9] >/dev/null; then
                   echo "$2 is not port number Error\n";
                   exit;
                else
                   echo "redis prot= $2" ;
                 if  (( $2 < 1024  )); then 
                  echo "<1024" ;
                  exit; 
                fi
                fi
                REDISPORT=$2
                 echo "redis prot1= $REDISPORT" ;
                #echo "$2" |sed 's/\.\|-\|+\|%\|\^//g'  | grep [^0-9] >/dev/null && echo "$2 is not number\n" || echo "$2 is number";
               # echo $2 
                netstat -anp |grep  $REDISPORT

                ;;
        setup)
                # 将编译好的redis 安装到指定目录 
                cp runredis.sh  /etc/init.d/redis_$REDISPORT
                chmod +x /etc/init.d/redis_$REDISPORT
                cp redis.conf  $CONF
                sed -i "s/6379/$REDISPORT/g" $CONF
                sed -i "s:SETUPDIR:${SETUPDIR}:g" $CONF
                #cp redis.service  $SERVICECONF
                #sed -i "s/6379/$REDISPORT/g" $SERVICECONF 
                #echo " cp ok"
                systemctl daemon-reload
                update-rc.d redis_${REDISPORT} defaults && echo "setup redis_${REDISPORT}  Success!"
                /lib/systemd/systemd-sysv-install enable redis_${REDISPORT} 
             
                
                echo " start ok"
                # if command -v chkconfig >/dev/null 2>&1; then
                #         # we're chkconfig, so lets add to chkconfig and put in runlevel 345
                #         chkconfig --add redis_${REDISPORT} && echo "Successfully added to chkconfig!"
                #         chkconfig --level 345 redis_${REDISPORT} on && echo "Successfully added to runlevels 345!"
                # elif command -v /usr/sbin/update-rc.d >/dev/null 2>&1; then
	        # #   if we're not a chkconfig box assume we're able to use update-rc.d
	        #        update-rc.d redis_${REDISPORT} defaults && echo "setup redis_${REDISPORT}  Success!"
                #  else
                #         echo "No supported init tool found."
                #         echo "update-rc.d redis_${REDISPORT} defaults"
                # fi 
                 /etc/init.d/redis_$REDISPORT start
                 echo " setup /etc/init.d/redis_$REDISPORT ok "  
                ;;
        install)  #只执行一次就可以了
                mkdir $SETUPDIR
                mkdir $SETUPDIR/db
                mkdir $SETUPDIR/log
                echo "mkdir $SETUPDIR " 
                make PREFIX=$SETUPDIR install
                #sudo adduser --system --group --no-create-home redis
                echo " adduser group redis ok"
                echo " install Successfully ok "  
                ;;
        start)   
               

                if [ ! -d "/run/redis" ]
                then
                       
                        cd /
                        umask 077  
                        #chmod 0755 /run
                        mkdir -p /run/redis
                        #chmod 0755 /run/redis
                        #chown -R redis:redis /run/redis
                        echo " mkdir redis..."    
                fi  

                if [ -f $PIDFILE ]   
                then   
                        echo "$PIDFILE exists, process is already running or crashed."  
                else  
                        echo "Starting Redis server..."    
                        $EXEC $CONF --supervised systemd &
                fi   
                if [ "$?"="0" ]   
                then   
                        echo "Redis is running..."  
                fi   
                ;;
        stop1)
 
                 $REDIS_CLI -p $REDISPORT  SHUTDOWN
                  echo "Redis stopped1"  
                 ;; 
        stop)   

                if [ ! -f $PIDFILE ]   
                then   
                        echo "$PIDFILE exists, process is not running."  
                else  
                        PID=$(cat $PIDFILE)   
                        echo "Stopping..."  
                       $REDIS_CLI -p $REDISPORT  SHUTDOWN    
                        sleep 2  
                       while [ -x $PIDFILE ]   
                       do  
                                echo "Waiting for Redis to shutdown..."  
                               sleep 1  
                        done   
                        echo "Redis stopped"  
                fi   
                ;;   
         status)
                PID=$(cat $PIDFILE)
                if [ ! -x /proc/${PID} ]
                then
                        echo 'Redis is not running'
                else
                        echo "Redis is running ($PID)"
                fi
        ;;
        restart|force-reload)   
                ${0} stop   
                ${0} start   
                ;;   
        *)   
               #echo "Usage: /etc/init.d/redis_$REDISPORT {start|stop|restart|force-reload}" >&2  
                exit 1  
esac
