#! /usr/bin/env bash

namespace=$1
if [[ -z "$namespace" ]]; then
    echo "Missing required input, namespace"
    exit 1
fi

echo "You are about to create a namespace: $namespace."
echo "Continue? (y)/n"
read;
if [[ -z "$REPLY" ]]; then
    REPLY="y"
fi

if [[ "$REPLY" != "y" ]]; then
    echo "Aborting..."
    exit 1
fi

cat <<-EOM | kubectl apply -f -
{
  "apiVersion": "v1",
  "kind": "Namespace",
  "metadata": {
    "name": "$namespace",
    "labels": {
      "name": "$name"
    }
  }
}
EOM
