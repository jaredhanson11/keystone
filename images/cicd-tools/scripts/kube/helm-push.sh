#! /usr/bin/env bash
# Lint, then package and push helm chart to endergy repo.
# Usage:
#   ./helm-push.sh <chart-dir>
# Requires: $HELM_REPO_USER
#           $HELM_REPO_PASSWORD
#           $HELM_REPO_URL (HAS TO END IN /, ex: "https://nexus.goflok.com/repository/helm/")
set -e

if [[ -z "$HELM_REPO_PASSWORD" || -z "$HELM_REPO_USER" || -z $HELM_REPO_URL ]]; then
    echo "Missing required inputs."
    echo "HELM_REPO_USER, HELM_REPO_PASSWORD, HELM_REPO_URL"
    exit 1
fi

helm dependency update $1 && \
helm lint $1 --strict --debug && \
mkdir -p ~/.cicd-tools/helm && \
CHART_PACKAGE="$(helm package -d ~/.cicd-tools/helm/ "$1" | cut -d":" -f2 | tr -d '[:space:]')" && \
curl -u "$HELM_REPO_USER:$HELM_REPO_PASSWORD" "$HELM_REPO_URL" --upload-file $CHART_PACKAGE

