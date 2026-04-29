#!/bin/sh

aws s3 cp "$1" - | gunzip -c | jq . > "$2"
