#!/bin/bash

# **Mission**: Write a script that monitors a directory for any changes (file creation, modification, or deletion) and logs the changes with a timestamp.

Directory=$HOME/projects/Arena

checksum="$(ls -lR "$Directory" | md5sum | awk '{print $1}')"

while true; do
	checksum2="$(ls -lR $Directory | md5sum | awk '{print $1}')"
	timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
	if [ "$checksum" != "$checksum2" ]; then
		echo "[$timestamp] change detected"
		checksum="$checksum2"
	fi
	sleep 1
done
