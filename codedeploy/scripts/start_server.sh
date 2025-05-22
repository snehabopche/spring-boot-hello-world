#!/bin/bash
nohup java -jar /home/ec2-user/app/spring-boot-hello-world-0.0.1-SNAPSHOT.jar > /home/ec2-user/app.log 2>&1 &

