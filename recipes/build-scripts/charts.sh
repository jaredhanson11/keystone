#! /usr/bin/env bash

CHART_DIR=$1

if [[ -z "$CHART_DIR" ]]; then
    echo "Incorrect input."
    exit 1
fi

ordered_charts=(lib)
charts=($(ls $CHART_DIR))

for chart in "${charts[@]}"; do
    if [[ ! " ${ordered_charts[@]} " =~ " ${chart} " ]]; then
        ordered_charts+=($chart)
    fi
done

echo ${ordered_charts[@]}
