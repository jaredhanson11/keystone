#! /usr/bin/env bash
# Returns array of arrays based on manifest.yaml on stacks to deploy.
#   "<chart-name> <values-file>"
# Usage:
#   ./triggers.sh <deployment-key>

# Set defaults
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
deploys_dir="./deploys"
empty_stack_key="_default" # Special value signaling default stack

# Get inputs
deploy_key=$1
if [[ -z "$deploy_key" ]]; then
    echo "Missing required input."
    echo "./triggers.sh <deployment-key>"
    exit 1
fi

# Loop deployments for deploy_key configured in manifest
deploys=$(yq r $deploys_dir/manifest.yaml -j $deploy_key | jq .[] -c)
>&2 echo "Deployments for deploy_key: $deploy_key:"
>&2 echo "$(echo "$deploys" | jq .)"
for deploy in ${deploys[@]}; do
    deploy_name=$(echo $deploy | jq -r .name)
    namespace=$(echo $deploy | jq -r .namespace)
    chart_name=$(echo $deploy | jq -r .chartName)
    stacks=($(echo $deploy | jq -rc .stacks[] ))

    # Check if value files for name/namespace is of proper stack
    deploy_values=$(find $deploys_dir/$namespace -name "$deploy_name.*yaml")
    >&2 echo "Potential values for namepace: $namespace:"
    >&2 echo "$deploy_values"
    for values_file in ${deploy_values[@]}; do
        values_filename=$(basename $values_file)
        deploy=$(echo $values_filename | sed 's/.yaml//g')
        IFS='.' read -r -a deploy_split <<< $(echo "$deploy")

        # If stacks is empty (or only empty string(s) i.e. ["", ""]), apply all stacks
        if [[ ${#stacks[@]} -eq 0 ]]; then do_deploy=1; fi
        stack=${deploy_split[1]}
        _stack="$stack"
        # If empty stack, use "_default" as psuedo stack name
        if [[ -z "$_stack" ]]; then _stack=$empty_postfix_key; fi
        # Check if values stack in "stacks" array
        for allowed_stack in ${stacks[@]}; do
            if [[ "$_stack" == "$allowed_stack" ]]; then do_deploy=1; fi 
        done

        if [[ do_deploy -eq 1 ]]; then
            do_deploy=0
            echo "$chart_name $values_file"
        fi
    done
done
