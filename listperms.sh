#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

filename="$1"
if [ ! -e "$filename" ]; then
  echo "File '$filename' not found."
  exit 1
fi

permission_numeric=$(stat -c "%a" "$filename")
permission_rwx=$(stat -c "%A" "$filename")

echo "Numeric Permissions: $permission_numeric"
echo "rwx Permissions:     $permission_rwx"
