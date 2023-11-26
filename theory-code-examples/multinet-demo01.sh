#!/bin/bash

server_file='/vagrant/servers'

if [[ ! -e $server_file ]]; then
    echo "Cannot open $server_file." >&2
    exit 1
fi

cat $server_file | while read -r server; do
    echo "Pinging $server"
    if ping -c 1 "$server" >/dev/null; then
        echo "$server up"
    else
        echo "$server down"
    fi
done
