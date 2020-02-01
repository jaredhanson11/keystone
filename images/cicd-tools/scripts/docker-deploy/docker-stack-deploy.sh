#! /usr/bin/env bash

type=$1
deploys_dir=$2

if [[ -z "$deploys_dir" ]]; then
    deploys_dir="/deploys"
fi

all_stacks=($(ls ${deploys_dir}/*.yml))
update_stacks=("landing-page.yml")

if [[ "$type" == "init" ]]; then
    stacks=${all_stacks[@]}
fi

if [[ "$type" == "update" ]]; then
    stacks=${update_stacks[@]}
fi

if [[ -z "$stacks" ]]; then
    echo "Required input (init, update)."
    exit 1
fi

stack_deploy="docker stack deploy"
for stack in ${stacks[@]}
do
    stack_deploy+=" -c $stack"
done
echo $stack_deploy