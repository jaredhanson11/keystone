#!/bin/bash
docker run -d -p $PORT:8080 -v $JENKINS_DATA:/var/jenkins_home $JENKINS_IMG