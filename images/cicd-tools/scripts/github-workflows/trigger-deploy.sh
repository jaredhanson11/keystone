#! /usr/bin/env bash

curl --header 'Authorization: token ${GITHUB_KEY}' \
     --header 'Accept: application/vnd.github.ant-man-preview+json' \
     -X 'POST'
     --location https://api.github.com/${GITHUB_USER}/${GITHUB_REPO}/deployments
