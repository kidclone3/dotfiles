#!/bin/bash

bluetooth_print() {
    bluetoothctl | grep --line-buffered 'Device\|#' | while read -r REPLY; do
        if [ "$(systemctl is-active "bluetooth.service")" = "active" ]; then
            printf '#1'

            # Get the list of Bluetooth cards
            devices_paired=$(pactl list short cards | grep bluez_card | awk '{print $2}' | tac)
            counter=0

            for device in $devices_paired; do
                device_info=$(pactl list cards | grep -A 20 "$device")

                if echo "$device_info" | grep -q "a2dp_sink"; then
                    device_output=$(echo "$device_info" | grep "device.description = " | cut -d ' ' -f 3- | tr -d '"')
                    # Wait 2s to get the battery info
                    sleep 2
                    device_battery_percent=$(echo "$device_info" | grep "bluetooth.battery" | awk -F'[=]' '{print $2}' | tr -d ' %')
                    device_battery_percent=$(printf "%d" "$device_battery_percent")
                    if [ -n "$device_battery_percent" ]; then
                        if [ "$device_battery_percent" -gt 90 ]; then
                            device_battery_icon=""
                        elif [ "$device_battery_percent" -gt 60 ]; then
                            device_battery_icon=""
                        elif [ "$device_battery_percent" -gt 35 ]; then
                            device_battery_icon=""
                        elif [ "$device_battery_percent" -gt 10 ]; then
                            device_battery_icon=""
                        else
                            device_battery_icon=""
                        fi

                        display_output="$device_output $device_battery_icon $device_battery_percent%"
                    fi

                    if [ $counter -gt 0 ]; then
                        printf ", %s" "$display_output"
                    else
                        printf " %s" "$display_output"
                    fi

                    counter=$((counter + 1))
                fi
            done

            printf '\n'
        else
            echo "#2"
        fi
    done
}

bluetooth_toggle() {
    if bluetoothctl show | grep -q "Powered: no"; then
        bluetoothctl power on >> /dev/null
        sleep 1
        notify-send "Bluetooth" "Bluetooth turned on, pairing latest device"
        while IFS= read -r line; do
            bluetoothctl connect "$line" >> /dev/null
        done < <(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
        notify-send "Bluetooth" "Tried to connect to all paired devices"
    else
        # Show confirmation dialog using rofi
        ans=$(echo -e "No\nYes" | rofi -dmenu -i -p "Do you want to disconnect all paired Bluetooth devices?")
        if [[ $ans == "Yes" ]]; then
            while IFS= read -r line; do
                bluetoothctl disconnect "$line" >> /dev/null
            done < <(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2 | tac)
            bluetoothctl power off >> /dev/null
        fi
    fi
}

case "$1" in
    --toggle)
        bluetooth_toggle
        ;;
    *)
        bluetooth_print
        ;;
esac