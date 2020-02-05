#! /usr/bin/env bash
# Deploy stacks
set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
$SCRIPT_DIR/../kube/helm-deploy.sh
echo "LOOP THROUGH DEPLOYS AND REDEPLOY"
