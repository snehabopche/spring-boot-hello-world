#!/bin/bash

JAR_NAME="app.jar"

echo "Stopping application..."

PID=$(pgrep -f "$JAR_NAME")

if [ -n "$PID" ]; then
  echo "Found running app with PID: $PID. Stopping it..."
  kill $PID
  sleep 5

  if pgrep -f "$JAR_NAME" > /dev/null; then
    echo "App did not stop. Forcing termination..."
    kill -9 $PID
  else
    echo "Application stopped successfully."
  fi
else
  echo "Application not running. Nothing to stop."
fi

