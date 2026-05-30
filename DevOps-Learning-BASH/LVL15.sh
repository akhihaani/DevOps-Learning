#!/bin/bash

# **Mission**: Combine the skills you've gained! Write a script that:

#1. Presents a menu to the user with the following options:
# - Check disk space
# - Show system uptime
# - Backup the Arena directory and keep the last 3 backups
# - Parse a configuration file settings.conf and display the values
# 2. Execute the chosen task.

set -euo pipefail

KEEP=3
SRC=$HOME/projects/Arena
DEST=${2:-}

show_menu() {
echo "1) Check disk space"
echo "2) Show system uptime"
echo "3) Backup Arena Directory and keep last 3 Backups"
echo "4) Parse configuration file settings.conf"
echo "q) Quit"
}

task_disk() { df -h; }
task_uptime() { uptime; }

task_backup() { if [ -z "$DEST" ]; then
	read -rp "Input Backup Directory: " DEST
fi

mkdir -p "$DEST"

SRC_ABS=$(realpath -m "$SRC")
DEST_ABS=$(realpath -m "$DEST")

case "$DEST_ABS" in
  "$SRC_ABS"/*)
    echo "Error: destination cannot be inside source"
    exit 1
    ;;
esac

echo "Directory accepted; DEST=$DEST_ABS"

ts=$(date +%Y%m%d%H%M%S )
base=$(basename "$SRC_ABS")
archive="$DEST_ABS/${base}-${ts}.tar.gz"

tar -czf "$archive" -C "$(dirname "$SRC_ABS")" "$base"

[ -s "$archive" ] || { echo "backup failed"; exit 1; }

du -sh "$archive" | awk '{print $1}'

ls -1t "$DEST_ABS/${base}-"*.tar.gz 2>/dev/null | tail -n +$((KEEP+1)) | while IFS= read -r f; do rm -- "$f"; done
}

task_config() { cat > settings.conf <<EOF
USER=haani
PORT=8080
DEBUG=true
EOF
CONF="settings.conf"

while IFS= read -r line; do
    key="${line%%=*}"
    value="${line#*=}"
    echo "Key: $key, Value: $value"
done < "$CONF"
}

while true; do
        show_menu
        read -rp "Choose: " choice
        case "$choice" in
                1) task_disk ;;
                2) task_uptime ;;
                3) task_backup ;;
		4) task_config ;;
                q|Q) exit 0 ;;
                *) echo "Invalid choice" ;;
        esac
        echo
        read -n1 -r -p "Press any key to return to menu..."
done

