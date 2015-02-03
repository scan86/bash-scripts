#!/bin/bash

set -o nounset

# global vars #
fullpath=$(readlink -f $0)
scriptDir=$(dirname $fullpath)

logfile=""

function log() {
 local msg dt

 msg=$@
 dt=$(date "+%F %H:%M:%S")
 
 if [ ! -z $logfile ]
 then
	 echo $dt : $msg >> $logfile
 else
	 echo $dt : $msg
 fi
}

function print_help() {
 echo "Help block here..."
 exit 1
}

while [ $# -ne 0 ]
do
	case "$1" in
		--key)
			value=$2
			shift; shift;
		;;
		*)
			print_help
			exit 1
		;;

	esac
done


