#! /usr/bin/env bash
# Lint, then package and push helm chart to endergy repo.
# Usage:
#   ./helm-push.sh <chart-dir>
set -e
helm dependency update $1 && \
helm lint $1 --strict --debug && \
helm push $1 vamble --dependency-update --force --debug
