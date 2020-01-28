#! /bin/bash
# This script pushes artifacts in this repository.
#   pushes are determine by `make push`
set -x
docker login -u "${DOCKER_USER}" -p "${DOCKER_PASS}"
make push