#!/bin/bash

# Mission: Write a script that accepts a filename as an argument and prints the number of lines in that file. If no filename is provided, display a message saying 'No file provided'.

file_name=$1

if [ $# -eq 0 ] ; then 
	echo "No file provided"
else
	[ -f "$1" ] && wc -l "$file_name"
fi
