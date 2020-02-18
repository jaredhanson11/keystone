#! /usr/bin/env bash
docker run -d -p 8085:8080 pypiserver/pypiserver:latest -P . -a . -p 8080 packages
