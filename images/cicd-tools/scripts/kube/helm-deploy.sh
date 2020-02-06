#! /usr/bin/env bash
# Deploy given chart, using values file.
#
# Usage:
#   ./helm-deploy.sh <chart-name> <values-file>
# Inputs
#   <chart-name>="endergy/helm-repo"
#   <values-file>="/path/to/<deploy-name>.<stack>.yaml"
#   $HELM_EXTRA_ARGS, (optional) extra args for helm upgrade command
set -e

# Get inputs
CHART_NAME=$1
VALUES_FILE=$2
if [[ -z "$CHART_NAME" || -z "$VALUES_FILE" ]]; then
    echo "Missing required inputs"
    echo "Usage:"
    echo "  ./helm-deploy.sh <chart-name> <values-file>"
    exit 1
fi

# Get deploy name & namespace from values file path
deploy=$(echo $VALUES_FILE | sed 's/.yaml//g')
IFS='.' read -r -a deploy_split <<< $(basename $deploy)
stack=${deploy_split[1]}
namespace=$(basename $(dirname $deploy))

# Add stack as postfix if needed
deploy_name=${deploy_split[0]}
if [[ ! -z "$stack" ]]; then
    deploy_name+="-$stack"
fi

# Perform upgrade
helm upgrade --install $deploy_name $CHART_NAME \
    --values $VALUES_FILE \
    --namespace $namespace \
    --dependency-update \
    $EXTRA_HELM_ARGS
