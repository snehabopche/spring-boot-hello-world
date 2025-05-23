#!/bin/bash

JAR_NAME="app.jar"
echo "[Stop Script] Stopping $JAR_NAME..."

PID=$(pgrep -f "$JAR_NAME")
if [ -n "$PID" ]; then
  kill $PID
  echo "[Stop Script] Application stopped."
else
  echo "[Stop Script] Application not running."
fi

