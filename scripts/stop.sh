#!/bin/bash

JAR_NAME="app.jar"

echo "[Stop Script] Stopping $JAR_NAME..."

PID=$(pgrep -f "$JAR_NAME")

if [ -n "$PID" ]; then
  echo "[Stop Script] Found PID: $PID. Stopping..."
  kill $PID
  sleep 5
  if pgrep -f "$JAR_NAME" > /dev/null; then
    echo "[Stop Script] Force stopping..."
    kill -9 $PID
  else
    echo "[Stop Script] Stopped successfully."
  fi
else
  echo "[Stop Script] Application not running."
fi

