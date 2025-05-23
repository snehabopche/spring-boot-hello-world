#!/bin/bash

APP_DIR="/opt/app"
JAR_NAME="app.jar"
LOG_FILE="/opt/app/app.log"

echo "[Start Script] Starting application..."

# Ensure app directory exists
sudo mkdir -p "$APP_DIR"
sudo chmod 777 "$APP_DIR"

# Copy jar from deployment archive to /opt/app
cp $(find /opt/codedeploy-agent/deployment-root/ -type f -name "$JAR_NAME" | head -1) "$APP_DIR"

# Create a new log file with proper permissions
touch "$LOG_FILE"
chmod 777 "$LOG_FILE"

cd "$APP_DIR"

# Start application in background and redirect output to log
nohup java -jar "$JAR_NAME" > "$LOG_FILE" 2>&1 &

sleep 5
if pgrep -f "$JAR_NAME" > /dev/null; then
  echo "[Start Script] Application started successfully."
else
  echo "[Start Script] Failed to start application"
  exit 1
fi

