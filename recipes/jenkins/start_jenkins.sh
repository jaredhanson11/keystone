#!/bin/bash
# Ability to set docker.sock location per OS
DOCKER_SOCK_LOC=${DOCKER_SOCK_LOC:-"/var/run/docker.sock"}

set -x
docker run -it \
-v $DOCKER_SOCK_LOC:/var/run/docker.sock \
-e JENKINS_DATA=~/.jenkins-data/ \
-d \
$@ \
endergy/jenkins