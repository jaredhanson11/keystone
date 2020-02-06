#! /usr/bin/env bash
# Triggers a deployment.
# Usage:
#   ./trigger-deploy <deploy-key>

# Get inputs
deploy_key=$1
if [[ -z "$deploy_key" ]]; then
    echo "Missing required inputs."
    echo "./trigger-deploy <deploy-key>"
    exit 1
fi

# Create deployment payload
payload="{\"deployKey\": \"$deploy_key\"}"
data="{\"ref\":\"master\", \"required_contexts\":[], \"payload\":$payload}"

# Curl
curl --user "${GITHUB_USER}:${GITHUB_KEY}" \
     --header 'Accept: application/vnd.github.ant-man-preview+json' \
     --header 'Content-Type: application/json' \
     --data "$data" \
     --request 'POST' \
     https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/deployments
