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
  log "main: run"

  log "main: done"
  
}

main "$@"
