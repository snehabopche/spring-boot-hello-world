#!/bin/bash
cd /opt/app
nohup java -jar app.jar > app.log 2>&1 &

