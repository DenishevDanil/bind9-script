#!/bin/bash

echo "Welcome to the DNS Server Update Script!"

read -p "Print A record: " newdns
read -p "Print ip address: " newip

dir="$(dirname "$(readlink -f "$0")")"
serialfile="$dir/serial"
serial=$(cat "$serialfile")
newserial=$((serial + 1))
echo $newserial > ./serial
