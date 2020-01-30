#! /usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DOCKER_USER=jaredhanson11
docker run \
    -v "/var/run/docker.sock":"/var/run/docker.sock" \
    -v ${SCRIPT_DIR}/../..:/keystone \
    -v ${HOME}/.ssh/:/root/.ssh/ \
    -p 6969:8000 \
    ${DOCKER_USER}/orchestrator --log-level=debug