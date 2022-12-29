#! /usr/bin/env bash
# Login to npm registry using yarn
# Usage:
#   ./yarn-login.sh
# Requires:
#   NPM_REGISTRY, NPM_EMAIL, NPM_USER, NPM_PASSWORD

if [[ -z "$NPM_REGISTRY" || -z "$NPM_EMAIL" || \
    -z "$NPM_USER" || -z "$NPM_PASSWORD" ]];
then
    echo "Missing required inputs."
    echo "./yarn-login.sh"
    echo "Requires: NPM_REGISTRY, NPM_EMAIL, NPM_USER, NPM_PASSWORD"
    exit 1
fi

yarn config set @summtech:registry $NPM_REGISTRY
yarn config set _auth $(echo -n $NPM_USER:$NPM_PASSWORD | base64)
yarn config set email $NPM_EMAIL
yarn config set always-auth true