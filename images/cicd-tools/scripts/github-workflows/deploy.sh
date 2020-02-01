#! /usr/bin/env bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ "$1" == "local" ]]; then
    $SCRIPT_DIR/../docker-deploy/docker-deploy-config.sh ./files
    $SCRIPT_DIR/../docker-deploy/docker-deploy-stack.sh ./deploys
else
    source $SCRIPT_DIR/../docker-deploy/docker-ssh-setup.sh
    $SCRIPT_DIR/../docker-deploy/docker-deploy-config.sh $files
    $SCRIPT_DIR/../docker-deploy/docker-deploy-stack.sh $
fi
