#!/bin/bash
 
if ! command -v qrencode &> /dev/null; then
    echo "Error: qrencode is not installed. Please install it using your package manager."
    exit 1
fi

PORT=8000
HOSTNAME="$(hostname -I | awk '{printf $1}')"
URL="http://$HOSTNAME:$PORT"

echo "LOCAL URL: $URL"
qrencode -t UTF8 $URL

python3 -m http.server $PORT
