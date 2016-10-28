#!/bin/bash

# env
script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
script_name=$(basename $script_path)
#


log() {
  local msg=$@ dt=$(date "+%F %H:%M:%S")

  echo "$dt: $0: $msg"
}

err() {
  local msg=$@ dt=$(date "+%F %H:%M:%S")

  echo "$dt: error: $msg"
  exit 1
}

main() {
  log "main: run"

  log "main: done"
  
}

main "$@"
