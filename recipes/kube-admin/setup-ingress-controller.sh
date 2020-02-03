#! /usr/bin/env bash
# This script sets up the nginx ingress controller using helm.

INGRESS_CONTROLLER_NODE_PORT=

helm install nginx-ingress stable/nginx-ingress \
--set controller.publishService.enabled=true \
--set controller.service.type=NodePort \
--set controller.service.nodePorts.http=30269 \
--set controller.service.enableHttps=false