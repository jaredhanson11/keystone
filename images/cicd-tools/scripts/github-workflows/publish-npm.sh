#! /usr/bin/env bash
# Builds and pushes python packages.
set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
$SCRIPT_DIR/../npm/yarn-setup.sh
make publish-npm-libs
