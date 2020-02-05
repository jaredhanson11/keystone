#! /bin/bash
# This script builds and pushed docker images.
docker login -u "${DOCKER_USER}" -p "${DOCKER_PASS}"
make push-images
