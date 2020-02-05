#! /usr/bin/env bash
# Deploy stacks
set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
$SCRIPT_DIR/../kube/kube-setup.sh
$SCRIPT_DIR/../kube/helm-setup.sh
$SCRIPT_DIR/../kube/helm-deploy.sh
