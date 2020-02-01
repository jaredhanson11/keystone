#! /usr/bin/env bash
set -e

deploys_dir=$1

if [[ -z "$deploys_dir" ]]; then
    deploys_dir="/deploys"
fi

stacks=($(ls ${deploys_dir}/*.yml))

stack_deploy="docker stack deploy"
for stack in ${stacks[@]}
do
    stack_deploy+=" -c $stack"
done
stack_deploy+=" endergy"

export $(cat ${deploys_dir}/.remote.env) && $stack_deploy
