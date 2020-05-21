#! /usr/bin/env bash

secret_name=$1
literals=""
for literal in "${@:2}"
do
    echo "$literal"
    literals+=" --from-literal $literal"
done
if [[ -z "$secret_name" ]]; then
    echo "Missing required input, secret_name"
    exit 1
fi
if [[ -z "$literals" ]]; then
    echo "Missing at least one secret to set."
    exit 1
fi


echo "You are about to create run the following command:"
echo "kubectl create secret generic $secret_name $literals"
echo ""
echo "Continue? (y)/n"
read;
if [[ -z "$REPLY" ]]; then
    REPLY="y"
fi

if [[ "$REPLY" != "y" ]]; then
    echo "Aborting..."
    exit 1
fi


kubectl create secret generic $secret_name $literals
