#!/bin/bash
warp_toggle() {
    if warp-cli status | grep -q "Connected"; then
        warp-cli disconnect
        wait
        notify-send "Warp" "🌥  turned off"
    else
        warp-cli connect
        wait
        notify-send "Warp" "🌥  turned on"
    fi
}

warp_print() {
    if warp-cli status | grep -q "Connected"; then
        printf 'Warp:  On '
    else
        printf 'Warp:  Off '
    fi
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