#!/bin/bash

echo
echo "MariaDB Galera Backup Agent"
echo "---------------------------"
echo "mode: $1"
echo "started: `date`"
echo

case "$1" in
	sleep)
		echo "Sleeping forever..."
		sleep infinity
		exit
		;;
	bash)
		echo "Executing ad-hoc bash command: $@..."
		shift 1
		/bin/bash "$@"
		exit
		;;
	agent)
		if [ -z $INC_BACKUP_INTERVAL ]; then
			export INC_BACKUP_INTERVAL=15m
		else 
			export INC_BACKUP_INTERVAL=$INC_BACKUP_INTERVAL
		fi
		echo "Starting automated backup agent with incrementals every ${INC_BACKUP_INTERVAL}..."
		echo "(sleeping 3m to allow for MariaDB node initialization)"
		sleep 3m
		
    while [ 1 ]
    do
	    /usr/local/bin/percona-backup.sh			
			sleep $INC_BACKUP_INTERVAL
    done
		;;
	backup)
		if [ -z $INC_BACKUP_INTERVAL ]; then
			export INC_BACKUP_INTERVAL=15m
		else 
			export INC_BACKUP_INTERVAL=$INC_BACKUP_INTERVAL
		fi
		echo "Starting ad-hoc backup..."
		/usr/local/bin/percona-backup.sh
		;;
	restore)
		if [ -z $SOURCE_BACKUP ]; then
			export SOURCE_BACKUP=latest		
		else 
			export SOURCE_BACKUP=$SOURCE_BACKUP
		fi
		if [ -z $SOURCE_INCREMENT ]; then
			export SOURCE_INCREMENT=latest		
		else 
			export SOURCE_INCREMENT=$SOURCE_INCREMENT
		fi
	
		echo "Starting ad-hoc restore to galera cluster seed..."
    /usr/local/bin/percona-restore.sh
		;;
	*)
    echo "invalid argument!"
		echo "usage: sleep|bash|agent|backup|restore"
    sleep 10s
		exit 1
esac



