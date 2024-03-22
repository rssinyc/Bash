#!/usr/bin/bash
num1=$1
num2=$2

if [ $# -ne 2 ] || ! [[ $1 =~ [[:digit:]] && $2 =~ [[:digit:]] ]]; then
    echo "You need two valid numeric arguments"
    exit 1
fi

num3=$((num1 + num2))

echo "$num3"
