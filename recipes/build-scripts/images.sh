#! /usr/bin/env bash

IMG_DIR=$1

if [[ -z "$IMG_DIR" ]]; then
    echo "Incorrect input."
    exit 1
fi

ordered_images=(serverbase cicd-tools)
images=($(ls $IMG_DIR))

for image in "${images[@]}"; do
    if [[ ! " ${ordered_images[@]} " =~ " ${image} " ]]; then
        ordered_images+=($image)
    fi
done

echo ${ordered_images[@]}
