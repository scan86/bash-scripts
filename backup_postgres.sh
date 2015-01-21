#!/bin/bash

set -o nounset

# global vars #

  # dump
dbs=""
local_dir="$HOME/postgres"

 # upload
upload=0
user=$USER
host=""
remote_dir="$local_dir"

  # rotate
rotate=0
days=""

  # logging
logfile=""

function log() {
 local msg dt

 msg=$@
 dt=$(date "+%F %H:%M:%S")
 
 if [ ! -z "$logfile" ]
 then
	 echo $dt : $msg >> $logfile
 else
	 echo $dt : $msg
 fi

}

function print_help() {
  #echo "Help block here..."
  echo "$0 <--db name1...--db name2> [--rotate days_num] [--log-file file] [--local-dir dir] [--host ip|name] [--user user] "
  exit 1
}


while [ $# -ne 0 ]
do
	case "$1" in
		--host)
			host=$2
			upload=1
			shift; shift;
		;;
		--user)
			user=$2
			shift; shift;
		;;
		--help)
			print_help
			exit 1
		;;
		--db)
			dbs="$2 $dbs"
			shift; shift;
		;;
		--rotate)
			days=$2
			rotate=1
			shift; shift;
		;;
		--log-file)
			logfile=$(readlink -f $2)
			shift; shift;
		;;
		--local-dir)
			local_dir=$(readlink -f $2)
			remote_dir=$local_dir
			shift; shift;
		;;
		*)
			print_help
			exit 1
		;;
	esac
done

[ -z "$dbs" ] && { echo "Empty dbs"; exit 1; }


# Run
log "Run backup..."
for db in $dbs
do
  dump_file=$local_dir/${db}-$(date +%F-%H-%M).dump
 
  log "Dump db $db to $dump_file ..."
  sudo -u postgres pg_dump -F c -Z 0 $db > $dump_file

  log "Dump exit code : $?"
done


if [ $rotate -eq 1 ]
then
  log Run rotate days=$days dir=$local_dir
 
  find_opts="-maxdepth 1 -name "*.dump" -mtime +${days} -type f" 
  num=$(find $local_dir $find_opts | wc -l)
  if [ $num -ge 0 ]
  then
    log Rotate nobject num : $num
    log Rotated : $(find $local_dir $find_opts | xargs rm -vf)
  fi
fi

if [ $upload -eq 1 ]
then

  log Run upload user=$user host=$host remote_dir=$remote_dir

  ssh ${user}@${host} test -d $remote_dir || { log Error remote_dir $remote_dir ; exit 1; }
  rsync -aW --delete $local_dir/ ${user}@${host}:$remote_dir
  
  #log ssh -o StrictHostKeyChecking=no ${user}@${host} test -d $remote_dir
  #log rsync -aW --delete $local_dir/ ${user}@${host}:$remote_dir
fi

