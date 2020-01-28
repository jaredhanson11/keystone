#! /bin/bash
# This script pushes artifacts in this repository.
#   pushes are determine by `make push`
set -x
cd $RUNNER_WORKSPACE
make push