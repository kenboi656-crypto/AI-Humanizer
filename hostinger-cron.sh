#!/bin/bash

# AI-HUMANIZER HOSTINGER MAINTENANCE CRON JOB
# Add to crontab: crontab -e
# Then add: 0 2 * * * /home/username/public_html/hostinger-cron.sh

LOG_FILE="/home/username/logs/ai-humanizer-cron.log"
APP_DIR="/home/username/public_html"

echo "[$(date)]" >> "$LOG_FILE"

cd "$APP_DIR"

# Check if application is running
if ! pgrep -f "node server.js" > /dev/null; then
    echo "Application stopped. Restarting..." >> "$LOG_FILE"
    nohup node server.js > /dev/null 2>&1 &
    echo "Restarted at $(date)" >> "$LOG_FILE"
else
    echo "Application running normally" >> "$LOG_FILE"
fi

# Check disk space
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 80 ]; then
    echo "WARNING: Disk usage at ${DISK_USAGE}%" >> "$LOG_FILE"
fi

# Clean old logs (keep last 30 days)
find /home/username/logs -name "*.log" -mtime +30 -delete

echo "Cron job completed at $(date)" >> "$LOG_FILE"