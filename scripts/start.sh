#!/bin/bash

APP_DIR="/home/ec2-user/app"
JAR_NAME="app.jar"
JFROG_URL="https://<your-jfrog-url>/your-repo/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar"

echo "[Start Script] Starting application..."

mkdir -p $APP_DIR
curl -u <jfrog-username>:<jfrog-api-key> -o $APP_DIR/$JAR_NAME $JFROG_URL

cd $APP_DIR
nohup java -jar $JAR_NAME > app.log 2>&1 &

sleep 5
if pgrep -f "$JAR_NAME" > /dev/null; then
  echo "[Start Script] Application started successfully."
else
  echo "[Start Script] Failed to start application"
  exit 1
fi

