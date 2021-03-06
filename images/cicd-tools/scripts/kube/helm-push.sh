#! /usr/bin/env bash
# Lint, then package and push helm chart to endergy repo.
# Usage:
#   ./helm-push.sh <chart-dir> <repo-url>
# Requires: $HELM_REPO_USER
#           $HELM_REPO_PASSWORD
#           $HELM_REPO_URL

set -e
helm dependency update $1 && \
helm lint $1 --strict --debug && \
mkdir -p ~/.cicd-tools/helm
helm package -u $1 -d ~/.cicd-tools/helm/
CHART_PACKAGE="$(helm package "$1" | cut -d":" -f2 | tr -d '[:space:]')"
curl -u "$HELM_REPO_USER:$HELM_REPO_PASSWORD" "$HELM_REPO_URL" --upload-file "$CHART_PACKAGE" | indent
rm $CHART_PACKAGE

