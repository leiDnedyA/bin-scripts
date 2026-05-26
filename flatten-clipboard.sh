#!/usr/bin/env bash

xclip -selection clipboard -o | tr '\n' ' ' | xclip -selection clipboard
