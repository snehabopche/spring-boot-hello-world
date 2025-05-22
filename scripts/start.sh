#!/bin/bash

APP_DIR="/home/ec2-user/app"
JAR_NAME="app.jar"
LOG_FILE="$APP_DIR/app.log"

cd $APP_DIR

# Check if app is already running
PID=$(pgrep -f $JAR_NAME)
if [ -n "$PID" ]; then
    echo "Application is already running with PID: $PID"
    exit 0
fi

echo "Starting application..."
nohup java -jar $JAR_NAME > $LOG_FILE 2>&1 &

sleep 3
NEW_PID=$(pgrep -f $JAR_NAME)
if [ -n "$NEW_PID" ]; then
    echo "Application started successfully with PID: $NEW_PID"
else
    echo "Failed to start application"
    exit 1
fi

