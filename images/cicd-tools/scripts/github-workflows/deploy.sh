#! /usr/bin/env bash
# Deploy helm charts to k8s
# Usage:
#   ./deploy.sh <deploy-key>

set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get deployment to be triggered
deploy_key=$1
if [[ -z "$deploy_key" ]]; then
    echo "Missing required inputs."
    echo "./deploy.sh <deploy-key>"
    exit 1
fi

# Setup kubectl (digital ocean) and helm
$SCRIPT_DIR/../kube/kube-setup-do.sh
$SCRIPT_DIR/../kube/helm-setup.sh

# Get charts and deploy them
deploys=$( $SCRIPT_DIR/../deploy/triggers.sh $deploy_key )
echo "$deploys" | while IFS= read -r deploy_args; do
    if [[ $deploy_args = *[![:space:]]* ]]; then
        echo "Deploying: $deploy_args"
        $SCRIPT_DIR/../kube/helm-deploy.sh $deploy_args
    fi
done
