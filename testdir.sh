#!/usr/bin/bash
if [ -d $1 ]; then
	echo "The file is a directory"
else 
	echo "The file is not a directory"
fi
