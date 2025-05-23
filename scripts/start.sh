#!/bin/bash

APP_DIR="/opt/app"
JAR_NAME="app.jar"
LOG_FILE="$APP_DIR/app.log"

echo "[Start Script] Starting application..."

# Create directory if it doesn't exist
mkdir -p "$APP_DIR"

# Ensure permissions
chmod 755 "$APP_DIR"

# Create or reset log file
touch "$LOG_FILE"
chmod 666 "$LOG_FILE"

cd "$APP_DIR"
nohup java -jar "$JAR_NAME" > "$LOG_FILE" 2>&1 &

sleep 5
if pgrep -f "$JAR_NAME" > /dev/null; then
  echo "[Start Script] Application started successfully."
else
  echo "[Start Script] Failed to start application"
  exit 1
fi

