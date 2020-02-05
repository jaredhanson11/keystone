#! /usr/bin/env bash
# Lint, then package and push helm chart to endergy repo.
# Usage:
#   ./helm-push.sh <chart-dir>
helm lint $1 --strict --debug
helm push $1 endergy --dependency-update --force --debug