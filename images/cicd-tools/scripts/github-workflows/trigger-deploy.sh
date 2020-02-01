#! /usr/bin/env bash

curl --header 'Authorization: token ${GITHUB_USER}:${GITHUB_KEY}' \
     --header 'Accept: application/vnd.github.ant-man-preview+json' \
     -X 'POST' \
     https://api.github.com/${GITHUB_USER}/${GITHUB_REPO}/deployments
