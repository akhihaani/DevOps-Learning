#!/bin/bash

# **Mission**: Write a script that reads a configuration file in the format `KEY=VALUE` and prints each key-value pair.

cat > settings.conf <<EOF
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

