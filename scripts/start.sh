#!/bin/bash

APP_DIR="/home/ec2-user/app"
JAR_NAME="app.jar"
LOG_FILE="$APP_DIR/app.log"

echo "Starting application..."

# Ensure correct permissions
chmod 755 $APP_DIR
touch $LOG_FILE
chmod 666 $LOG_FILE

# Start app
cd $APP_DIR
nohup java -jar $JAR_NAME > $LOG_FILE 2>&1 &

# Check if started
sleep 5
if pgrep -f "$JAR_NAME" > /dev/null; then
  echo "Application started successfully."
else
  echo "Failed to start application"
  exit 1
fi

