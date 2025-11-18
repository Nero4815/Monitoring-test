#!/bin/bash

LOGFILE="/var/log/monitoring.log"
API_URL="https://test.com/monitoring/test/api"
PROCESS_NAME="test"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

CURRENT_PID=$(pgrep -х "^$PROCESS_NAME$")

if [ -z "$CURRENT_PID" ]; then
    # Процесс не запущен — ничего не делаем
    exit 0
fi

STATE_FILE="/var/lib/monitoring/test.pid"

if [ -f "$STATE_FILE" ]; then
    OLD_PID=$(cat "$STATE_FILE")
else
    OLD_PID=""
fi

mkdir -p "$(dirname "$STATE_FILE")"
echo "$CURRENT_PID" > "$STATE_FILE"

if curl -fsS --max-time 10 "$API_URL" > /dev/null 2>&1; then
    # API доступен
    if [ "$OLD_PID" != "$CURRENT_PID" ]; then
        log_message "Process '$PROCESS_NAME' was restarted (old PID: $OLD_PID, new PID: $CURRENT_PID)."
    fi
else
    # API недоступен
    log_message "Monitoring server $API_URL is unreachable."
fi
