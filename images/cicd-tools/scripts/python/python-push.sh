#! /usr/bin/env bash
# Build and push python package from setup.py.
# Usage:
#   ./python-push.sh <package-dir>
# Requires:
#   TWINE_USERNAME, TWINE_PASSWORD, TWINE_REPOSITORY_URL

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

package_dir=$1
if [[ -z "$package_dir" || -z "$TWINE_PASSWORD" || \
    -z "$TWINE_USERNAME" || -z "$TWINE_REPOSITORY_URL" ]];
then
    echo "Missing required inputs."
    echo "./python-build.sh <package-dir-path>"
    echo "Requires: TWINE_USERNAME, TWINE_PASSWORD, TWINE_REPOSITORY_URL"
    exit 1
fi

$SCRIPT_DIR/python-build.sh $package_dir

pushd $package_dir
twine upload dist/*
popd
