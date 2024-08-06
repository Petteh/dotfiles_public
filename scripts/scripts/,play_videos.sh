#!/usr/bin/env bash

fd --no-ignore --max-depth 1 \
    -e mp4 -e mkv -e webm |
    sort | mpv "$@" --playlist=-
