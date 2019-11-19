#!/bin/sh
set -x

# Use this to create PV to store persistent data
# Usage:
#   create-pv.sh <pv-name> <local-dir> <allocated-size>

PV_CHART="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/pv"
helm template $PV_CHART --set name=$1 --set path=$2 --set size=$3 | kubectl apply -f -