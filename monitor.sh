#!/usr/bin/env bash
set -u

echo "=============================="
echo "     SERVER HEALTH MONITOR"
echo "=============================="
echo

echo "Checked at: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo

echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"
echo

echo "--- Memory Usage ---"
free -h
echo

echo "--- Disk Usage ---"
df -h /
echo

echo "--- System Load ---"
uptime
echo

echo "--- Service Status ---"
if systemctl is-active --quiet nginx; then
	echo "NGINX: RUNNING"
else
	echo "NGINX: NOT RUNNING"
fi
echo

echo "--- Disk Space Alert ---"
DISK_USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')
echo "Root filesystem usage: ${DISK_USAGE}%"
if [ "$DISK_USAGE" -ge 80 ]; then
	echo "WARNING: Disk usage is above 80%!"
else
	echo "OK: Disk usage is within limits."
fi
echo
