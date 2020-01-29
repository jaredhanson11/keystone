#! /bin/bash
# Wrapper that calls all the neccesary scripts within this repo.
#   Using this wrapper allows individual components to be added/removed more dynamically.
MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
$MYDIR/docker-setup.sh
