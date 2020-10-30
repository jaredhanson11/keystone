#! /usr/bin/env bash
# Setup helm to connect to helm repository.
# Requires: $HELM_REPO_USER
#           $HELM_REPO_PASSWORD
# Optional: $HELM_REPO_URL (default, https://helm.endergy.co/)
set -e

if [[ -z "$HELM_REPO_PASSWORD" || -z "$HELM_REPO_USER" ]]; then
    echo "Missing required inputs."
    echo "HELM_REPO_USER, HELM_REPO_PASSWORD"
    exit 1
fi

if [[ -z "$HELM_REPO_URL" ]]; then
    HELM_REPO_URL="https://helm.endergy.co/"
fi

helm repo add stable https://charts.helm.sh/stable/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add vamble $HELM_REPO_URL --username "$HELM_REPO_USER" --password "$HELM_REPO_PASSWORD"
