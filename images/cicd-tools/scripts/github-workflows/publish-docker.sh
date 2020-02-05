#! /usr/bin/env bash
# Builds and pushes docker images.
set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
$SCRIPT_DIR/../docker/push-docker-artifacts.sh
