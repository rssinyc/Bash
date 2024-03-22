#!/usr/bin/bash
NUM1=$1
NUM2=$2

if [ $# -ne 2 ] || ! [[ $1 =~ [[:digit:]] && $2 =~ [[:digit:]] ]]; then
    echo "You need two valid numeric arguments"
    exit 1
fi

NUM3=$((NUM1 + NUM2))

echo "$NUM3"
