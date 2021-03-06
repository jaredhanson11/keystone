#! /usr/bin/env bash
# Setup helm to connect to helm repository.
# Requires: $HELM_REPO_USER
#           $HELM_REPO_PASSWORD
#           $HELM_REPO_URL
set -e

if [[ -z "$HELM_REPO_PASSWORD" || -z "$HELM_REPO_USER" || -z $HELM_REPO_URL ]]; then
    echo "Missing required inputs."
    echo "HELM_REPO_USER, HELM_REPO_PASSWORD, HELM_REPO_URL"
    exit 1
fi

helm repo add stable https://charts.helm.sh/stable/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add summtech $HELM_REPO_URL --username "$HELM_REPO_USER" --password "$HELM_REPO_PASSWORD"
