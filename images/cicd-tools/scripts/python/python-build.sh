#! /usr/bin/env bash
# Build python module using setup.py
# Usage:
#   ./python-build.sh <package-dir>

package_dir=$1

if [[ -z "$package_dir" ]]; then
    echo "Missing required inputs."
    echo "./python-build.sh <package-dir-path>"
    exit 1
fi

pushd $package_dir
python3 setup.py sdist bdist_build
popd
