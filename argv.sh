#!/bin/bash

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

  [ $# -eq 0 ] && err "no args"

  local date input do_load

  while [ $# -gt 0 ]; do
    case "$1" in
      --date)
        date=$2; 
        shift; shift;
      ;;
      --input)
        input=$2;
        shift; shift;
      ;;
      --load)
        do_load=1; shift;
      ;;
      *)
        err "unknown opt: $1"
      ;;
    esac
  done

  [ -z $date ] && err "no date defined"
  [ -z $input ] && err "no input dir defined"

  log "date=$date input=$input do_load=$do_load"

}

main "$@"
