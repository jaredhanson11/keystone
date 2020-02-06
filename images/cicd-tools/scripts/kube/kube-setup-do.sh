#! /usr/bin/env bash
# Setup .kubeconfig for Digital Ocean cluster.
# Requires: $DIGITALOCEAN_ACCESS_TOKEN
#           $DIGITALOCEAN_CLUSTER_NAME

if [[ -z "$DIGITALOCEAN_ACCESS_TOKEN" || -z "$DIGITALOCEAN_CLUSTER_NAME" ]]; then
    echo "Missing required inputs."
    echo "DIGITALOCEAN_ACCESS_TOKEN, DIGITALOCEAN_CLUSTER_NAME"
    exit 1
fi

doctl auth init
doctl kubernetes cluster kubeconfig save $DIGITALOCEAN_CLUSTER_NAME
