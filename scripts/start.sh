#!/bin/bash

APP_DIR="/home/ec2-user/app"
JAR_NAME="app.jar"
LOG_FILE="$APP_DIR/app.log"

echo "[Start Script] Starting application..."

# Ensure the app directory exists
if [ ! -d "$APP_DIR" ]; then
  echo "[Start Script] Creating application directory..."
  mkdir -p "$APP_DIR"
fi

# Set correct ownership and permissions
chown ec2-user:ec2-user "$APP_DIR"
chmod 755 "$APP_DIR"

# Ensure log file is writable
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

