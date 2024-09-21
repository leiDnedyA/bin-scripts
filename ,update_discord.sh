#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

set -e

DEB_URL="https://discord.com/api/download?platform=linux&format=deb"
DOWNLOADS_PATH="/home/ayden/Downloads"

cd $DOWNLOADS_PATH

wget $DEB_URL

sudo apt-get install "$DOWNLOADS_PATH/$(ls -t | head -n 1)"

echo "Discord update successful."
