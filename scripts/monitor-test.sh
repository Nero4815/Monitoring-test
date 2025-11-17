#!/bin/bash

LOGFILE="/var/log/monitoring.log"
PROCESS_NAME="test"
MONITORING_HOST=""
MONITORING_PORT=""

touch "$LOGFILE" 2>/dev/null || { echo "Не удалось создать $LOGFILE"; exit 1; }

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

if ! pgrep -x "$PROCESS_NAME" > /dev/null; then
    exit 0
fi

CURRENT_PID=$(pgrep -x "$PROCESS_NAME" | head -n1)
PIDFILE="/var/run/monitor-test.pid"

if [ -f "$PIDFILE" ]; then
    PREVIOUS_PID=$(cat "$PIDFILE")
    if [ "$CURRENT_PID" != "$PREVIOUS_PID" ]; then
        log_message "Процесс '$PROCESS_NAME' был перезапущен (старый PID: $PREVIOUS_PID, новый PID: $CURRENT_PID)"
    fi
else
    echo "$CURRENT_PID" > "$PIDFILE"
    exit 0
fi

echo "$CURRENT_PID" > "$PIDFILE"

if ! nc -z "$MONITORING_HOST" "$MONITORING_PORT" 2>/dev/null; then
    log_message "Сервер мониторинга $MONITORING_HOST:$MONITORING_PORT недоступен"
fi
