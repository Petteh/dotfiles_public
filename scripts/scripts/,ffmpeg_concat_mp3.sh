#!/usr/bin/env bash

TMP_CONCAT_FILE=".TMP_concat_mp3.txt"

usage() {
    >&2 echo -e "\nConcats mp3 files"
    >&2 echo -e "\tUsage: $0 <output_file> <mp3_files>"
    exit "$1"
}

if [ -z "$1" ]; then
    >&2 echo -e "ERROR! No output name given. Exiting..."
    usage 1
fi
out_file="$1"
shift

if [ -z "$1" ]; then
    >&2 echo -e "ERROR! No input mp3s given. Exiting..."
    usage 2
fi

# Create concat demuxer file then perform concat
# https://trac.ffmpeg.org/wiki/Concatenate#demuxer
rm "$TMP_CONCAT_FILE"
for mp3 in "$@"; do
    echo "file '$mp3'" >> "$TMP_CONCAT_FILE"
done

ffmpeg -hide_banner \
    -f concat -safe 0 \
    -i "$TMP_CONCAT_FILE" \
    -c copy \
    "$out_file"

rm "$TMP_CONCAT_FILE"
