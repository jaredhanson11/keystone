#! /usr/bin/env bash
# Usage:
#   ./push-python-libs.sh <path-to-endergy> [<module-name>]
# If module-name not given, pushes all python libs
ENDERGY_DIR=$(echo "$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")")
LIB=$2
if [[ -z "$ENDERGY_DIR" ]]; then
    echo "Missing path to endergy dir."
    exit 1
fi

if [[ -z "$LIB" ]]; then
    ENTRYPOINT="--entrypoint=/scripts/github-workflows/publish-python.sh"
else
    RUN="/scripts/python/python-push.sh lib/${LIB}"
fi

docker run \
    -e TWINE_USERNAME=user \
    -e TWINE_PASSWORD=user \
    -e TWINE_REPOSITORY_URL=http://host.docker.internal:8085 \
    -e HOME=/github/workspace \
    --workdir /github/workspace \
    -v $ENDERGY_DIR:/github/workspace \
    $ENTRYPOINT \
    jaredhanson11/python-builder:latest $RUN

echo "Cleanup with:"
echo "del $ENDERGY_DIR/lib/*/dist/"
