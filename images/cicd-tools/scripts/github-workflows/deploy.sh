#! /usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

$SCRIPT_DIR/../github-workflows/docker-ssh-setup.sh
$SCRIPT_DIR/../github-workflows/docker-stack-deploy.sh init
