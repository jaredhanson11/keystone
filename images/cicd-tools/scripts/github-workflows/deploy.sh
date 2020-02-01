#! /usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

$SCRIPT_DIR/../docker-deploy/docker-ssh-setup.sh
$SCRIPT_DIR/../docker-deploy/docker-stack-deploy.sh init
