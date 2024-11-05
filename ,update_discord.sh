#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

DEB_URL="https://discord.com/api/download?platform=linux&format=deb"
DOWNLOADS_PATH="/home/ayden/Downloads"

cd $DOWNLOADS_PATH

wget $DEB_URL -O discord_update.deb
echo "New Discord .deb file has been downloaded. Installing..."
apt install ./discord_update.deb
rm ./discord_update.deb

