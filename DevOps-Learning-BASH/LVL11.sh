#!/bin/bash

# **Mission**: Create a script that checks the disk space usage of a specified directory and sends an alert if the usage exceeds a given threshold.

Directory=$HOME/projects/Arena

# du is disk usage. -s is summary, -b is in bytes
Diskspace="$(du -sb "$Directory" | awk '{print $1}')"

if [ "$Diskspace" -ge 5000 ] ; then
	echo "Disk Space above threshold"
else
	echo "$((5000 - $Diskspace)) bytes free"
fi
