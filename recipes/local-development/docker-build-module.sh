#! /usr/bin/env bash
MODULE_DIR=$(echo "$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")")
if [[ -z "$MODULE_DIR" ]]; then
    echo "Missing path to module dir."
    exit 1
fi
DOCKER_IMAGE_NAME=jaredhanson11-local/$(basename "$1")
docker build $MODULE_DIR --build-arg PIP_TRUSTED_HOST=host.docker.internal --build-arg PIP_EXTRA_INDEX_URL=http://host.docker.internal:8085/simple -t ${DOCKER_IMAGE_NAME}:latest
