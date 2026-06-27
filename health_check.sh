#!/usr/bin/env bash
set -euo pipefail

THRESHOLD="${1:-80}"
: > health.log

log() {
  local message="$*"
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$message" | tee -a health.log
}

check_disk() {
  local threshold="$1"
  local disk_usage

  disk_usage=$(df / | awk 'NR==2 {gsub("%", "", $5); print $5}')

  if [ "$disk_usage" -gt "$threshold" ]; then
    log "Warning: Disk usage is above ${threshold}%"
  else
    log "Disk OK"
  fi
}

check_processes() {
  local process_count

  process_count=$(ps aux | wc -l)
  log "Current process count: $process_count"
}

while true; do
  log "Checking system health..."
  check_disk "$THRESHOLD"
  check_processes
  sleep 30
done