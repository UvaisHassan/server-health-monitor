#!/usr/bin/env bash

HOSTNAME_VALUE=$(hostname)
TIMESTAMP=$(date -Is)
UPTIME_SECONDS=$(awk '{printf "%d", $1}' /proc/uptime)
MEMORY_PERCENT=$(free | awk '/Mem:/ {printf "%.1f", $3/$2*100}')
DISK_PERCENT=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')
LOAD_AVERAGE=$(awk '{print $1}' /proc/loadavg)

if systemctl is-active --quiet nginx; then
	NGINX_STATUS="running"
else
	NGINX_STATUS="stopped"
fi

printf '{
	"hostname": "%s",
	"timestamp": "%s",
	"uptime_seconds": %s,
	"memory_usage_percent": %s,
	"disk_usage_percent": %s,
	"load_average": %s,
	"nginx_status": "%s"
}\n' \
	"$HOSTNAME_VALUE" \
	"$TIMESTAMP" \
	"$UPTIME_SECONDS" \
	"$MEMORY_PERCENT" \
	"$DISK_PERCENT" \
	"$LOAD_AVERAGE" \
	"$NGINX_STATUS"
