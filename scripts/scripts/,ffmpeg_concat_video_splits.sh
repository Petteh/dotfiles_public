#!/usr/bin/env bash

TMP_CONCAT_FILE=".TMP_concat_video.txt"

usage() {
    >&2 echo -e "\nConcat video splits"
    >&2 echo -e "\tUsage: $0 <video splits>"
    exit "$1"
}

if [ -z "$1" ]; then
    >&2 echo -e "ERROR! No inputs given. Exiting..."
    usage 1
fi

# Create concat demuxer file then perform concat
# https://trac.ffmpeg.org/wiki/Concatenate#demuxer
touch "$TMP_CONCAT_FILE" && rm "$TMP_CONCAT_FILE"
for vid in "$@"; do
    echo "file '$vid'" >> "$TMP_CONCAT_FILE"
done

out_file=$(echo "$vid" | sed -E 's/_splits_[0-9\-]+/_concat/g')
if [ "$vid" == "$out_file" ]; then
    exit 2;
fi

ffmpeg -hide_banner \
    -f concat -safe 0 \
    -i "$TMP_CONCAT_FILE" \
    " -c copy" \
    "$out_file"

rm "$TMP_CONCAT_FILE"
