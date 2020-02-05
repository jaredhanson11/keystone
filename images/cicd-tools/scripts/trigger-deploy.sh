#! /usr/bin/env bash
curl --user "${GITHUB_USER}:${GITHUB_KEY}" \
     --header 'Accept: application/vnd.github.ant-man-preview+json' \
     --header 'Content-Type: application/json' \
     --data '{"ref":"master", "required_contexts": []}' \
     --request 'POST' \
     https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/deployments
