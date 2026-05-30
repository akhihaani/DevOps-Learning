#!/bin/bash

#**Mission**: Create a script that backs up a directory to a specified location and keeps only the last 5 backups.

# My understanding of the mission
# i should be able to choose a directory to backup.
# i should be able to choose which directory to backup to
# the script should only keep the last 5 usages and delete the ones that came before it
set -euo pipefail

KEEP=5

SRC=${1:-}
DEST=${2:-}

# Prompt only if missing
if [ -z "$SRC" ]; then
  read -rp "Input Source Directory: " SRC
fi
if [ -z "$DEST" ]; then
  read -rp "Input Backup Directory: " DEST
fi
# read -r SRC would read the input and put it into vairable SRC, the -p echoes a prompt for the user before their input

# Validate source
if [ ! -d "$SRC" ]; then
  echo "Source directory does not exist: $SRC"
  exit 1
fi

# Ensure destination exists
mkdir -p "$DEST"

# Guard: DEST must not be inside SRC
SRC_ABS=$(realpath -m "$SRC")
DEST_ABS=$(realpath -m "$DEST")
# realpath -m converts the path variable to its fullpath, showing all the folders before it, it's breadcrumbs
# SRC_ABS means Source Absolute, because its the absolute path

case "$DEST_ABS" in
  "$SRC_ABS"/*)
    echo "Error: destination cannot be inside source"
    exit 1
    ;;
esac
# case is like if statements, used for pattern matching. for the coder to understand what's happening here rather than extra functionality

echo "Directories accepted: SRC=$SRC_ABS DEST=$DEST_ABS"

ts=$(date +%Y%m%d%H%M%S )
base=$(basename "$SRC_ABS")
archive="$DEST_ABS/${base}-${ts}.tar.gz "
# timestamp marks the time the script ran
# basename takes a file name away from its parent directories, and keeps the filename
# tar is used to archive files or directories into a single file

tar -czf "$archive" -C "$(dirname "$SRC_ABS")" "$base"
# tar archives and compresses the source into the destination
# -c creates a new archive, -z compresses it with gzip, -f makes the next argument the filename for the archive
# -C changes parent directory of the source directory. It tells tar to go to the parent folder, takes the source directory and then switches it to the -czf variable (archive)
# dirname separates the file name from the parent directories, keeping the parent directories

[ -s "$archive" ] || { echo "backup failed"; exit 1; }
# Ensure the file was created and non-empty
# -s checks if a file exists and has a size greater than 0
# || means if command 1 fails, do command 2


du -sh "$archive" | awk '{print $1}'
# prints archive name with size
# -s is a summary of total size, -h means human readable


ls -1t "$DEST_ABS/${base}-"*.tar.gz 2>/dev/null | tail -n +$((KEEP+1)) | while IFS= read -r f; do rm -- "$f"; done
# Gets rid of old backups past 5
# ls -1t lists in a single column, listed by new. tail -n is usually 10, Keep+1 means 6 and we are starting at line 6. Each line is a backup. The sixth one due to ls -1t is always the oldest backup which then gets removed in the next command sequence after piping

exit 0
# script success! Yayyy!


