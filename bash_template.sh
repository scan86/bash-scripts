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

function exit_with_error() {
 local msg

 msg="ERR : $@"
 
 log $msg
 exit 2
}


# params
key=""

while [ $# -ne 0 ]
do
	case "$1" in
		--key)
			key=$2
			shift; shift;
		;;
		--help)
			print_help
		;;
		*)
			print_help
		;;

	esac
done
