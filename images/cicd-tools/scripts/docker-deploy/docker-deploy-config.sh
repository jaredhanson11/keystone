#! /usr/bin/env bash
set -e

configs_dir=$1

if [[ -z "$configs_dir" ]]; then
    configs_dir="/files"
fi

configs=($(ls ${configs_dir}/*))

for config in ${configs[@]}
do
    name=$(basename ${config})
    if [[ ! -z "$(docker config ls -q -f name=${name})" ]]; then
        docker config rm ${name};
    fi
    cat ${config} | docker config create ${name} -
done
    docker config ls
