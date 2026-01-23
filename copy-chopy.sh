#!/bin/bash

xclip -o -selection clipboard | cut -c1-8 | xclip -i -selection clipboard
