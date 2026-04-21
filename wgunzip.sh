#!/bin/sh

wget -O - $1 | gunzip -c | jq . > $2
