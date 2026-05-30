#!/bin/bash

# **Mission**: Write a script that monitors a directory for any changes (file creation, modification, or deletion) and logs the changes with a timestamp.

Directory=$HOME/projects/Arena

checksum=$(find $Directory -type f -printf "%p %s %T@\n" | md5sum | awk '{print $1}')

while true; do
	checksum2=$(find $Directory -type f -printf "%p %s %T@\n" | md5sum | awk '{print $1}')
	timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
	if [ "$checksum" != "$checksum2" ]; then
		echo "[$timestamp] change detected"
		checksum="$checksum2"
	fi
	sleep 1
done
