#!/usr/bin/bash
for i in `cat /etc/passwd | cut -d : -f 1`
do
	echo "$i"
done
