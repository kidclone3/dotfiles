#!/bin/bash
warp_toggle() {
    if warp-cli status | grep -q "Connected\|Connecting"; then
        warp-cli disconnect
        wait
        notify-send "Warp" "🌥  turned off"
    else
        warp-cli connect
        wait
        notify-send "Warp" "🌥  turned on"
    fi
    warp_print # Print the new status
}

warp_print() {
    printf "Warp: %s" "$(warp-cli status | awk 'NR==1 {print $3}')"
    printf '\n'
}

case "$1" in
    --toggle)
        warp_toggle
        ;;
    *)
        warp_print
        ;;
esac