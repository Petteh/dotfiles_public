#!/usr/bin/env bash

CMD_LOG="$( basename "$0" )_cmd.log"

usage() {
    >&2 echo -e "\nCuts video file into mp3 file"
    >&2 echo -e "\tUsage: $0 <input_video> <start> <stop>"
    exit 1
}

if [ $# -lt 1 ]; then
    >&2 echo -e "ERROR! No input video given. Exiting..."
    usage
fi
input="$1"
start="$2"
duration="$3"

out="out.mp3"
ffmpeg -hide_banner \
    -i "$input" \
    -ss "$start" -t "$duration" \
    -y "$out"

echo -e "ffmpeg -hide_banner -i '$input' -ss $start \t-t $duration \t-y '$out'\n" >> "$CMD_LOG"

mpv "$out"
