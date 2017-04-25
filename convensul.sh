#!/bin/bash

set -e

if [[ -z $1 || -z $2 || -z $3 || -z $4 ]]
then
    echo "Usage: convensul.sh <CONSUL_HOST> <CONSUL_TOKEN> <KV> <APP> [ARG_1] ... [ARG_N]"
    echo
    echo "Initializes environment with env vars from Consul YAML document and runs app."
    echo
    echo "      CONSUL_HOST       Consul agent address (you can also override port usinng ':')"
    echo "      CONSUL_TOKEN      Consul ACL token. Set to '-' to use value from CONVENSUL_TOKEN env var."
    echo "      KV                Path to config document in KV."
    echo "      APP               Child application to run"
    echo "      ARG_1 ... ARG_N   Optional arguments to pass to child application"
    echo
    echo "Created by Andrew Dunai <a@dun.ai>"
    exit 1
fi

HOST=$(echo $1 | awk -F: '{print $1}')
PORT=$(echo $1 | awk -F: '{print $2}')
PORT=${PORT:-8500}
TOKEN=$2
KV=$3
ARGS="${@:4}"

if [[ "$TOKEN" == "-" ]]
then
    TOKEN=$CONVENSUL_TOKEN
    if [[ -z "$TOKEN" ]]
    then
        echo "Error: CONVENSUL_TOKEN env var must be set if TOKEN is set to '-'."
        exit 1
    fi
fi

DATA=`curl -sS "http://${HOST}:${PORT}/v1/kv/${KV}?dc=dc1&token=${TOKEN}&raw"`

LINES=()

while read -r line
do
    key=`echo $line | cut -d: -f1 | xargs`
    value=`echo $line | cut -d: -f2- | xargs`
    LINES+=("$key=$value")
done <<< "$DATA"

env ${LINES[@]} ${ARGS}
