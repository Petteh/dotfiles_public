#!/usr/bin/env bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots";
SHUTTER_SOUND="TODO"

usage() {
    echo -e "Usage: $(basename "$0") <capture>"
    echo -e "\tValid <capture> = [all, select, screen, window]"
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi
capture="$1"

timestamp=$(date '+%Y-%m-%d-%Hh%Mm%Ss')
out_path="${SCREENSHOT_DIR}/${timestamp}.png";
case $capture in
    all)
        grim "$out_path"
        ;;
    select)
        grim -g "$(slurp)" "$out_path"
        ;;
    screen)
        grim -g "$(slurp -o)" "$out_path"
        ;;
    window)
        hyprctl -j activewindow |
            jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' |
            grim -g - "$out_path"
        ;;
    *)
        echo "ERROR: Invalid option '$capture'"
        usage
        ;;
esac

# Play shutter sound
ffplay -autoexit -nodisp "${SHUTTER_SOUND}" &> /dev/null &

# Copy to clipboard
wl-copy < "$out_path"

# Send notifiaction
notify-send "Screenshot saved" "'$out_path'" \
    -t 5000 -i "$out_path" -a "$(basename "$0")"
