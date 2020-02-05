#! /usr/bin/env bash
# Lints, builds and pushes docker charts.
set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
$SCRIPT_DIR/../kube/helm-setup.sh
make push-charts
