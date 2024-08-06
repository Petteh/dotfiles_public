#!/usr/bin/env bash

download_file="download.txt"
download_archive_file="download_archive.txt"

touch "$download_file"

yt-dlp \
    --concurrent-fragments 8 \
    --batch-file "$download_file" \
    --download-archive "$download_archive_file" \
    --embed-metadata --write-subs --write-auto-subs --embed-subs \
    --trim-filenames 222 \
    --merge-output-format mkv \
    "$@"
