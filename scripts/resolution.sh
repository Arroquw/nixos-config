#!/usr/bin/env bash
set -x
monitors=$(hyprctl monitors -j)

choice=$(echo "$monitors" | jq -r '.[] | "\(.name),\(.width)x\(.height)@\(.refreshRate),\(.description)"' \
    | rofi -dmenu -p "Select monitor" -theme-str 'window {width: 600px;}')

[ -z "$choice" ] && exit 1

monitor_options="$choice"
monitor_name="$(echo "${monitor_options}" | cut -d, -f1)"

resolution="$(echo "${monitor_options}" | cut -d, -f2)"

position="$(echo "${monitors}" | jq -r --arg NAME "${monitor_name}" '.[] | select(.name==$NAME) | "\(.x)x\(.y)"')"

scale="$(echo "${monitors}" | jq -r --arg NAME "${monitor_name}" '.[] | select(.name==$NAME) | .scale')"

echo "You selected: $monitor_name with resolution $resolution at pos $position"

action=$(printf "scale\nresolution" | rofi -dmenu -p "Change" -theme-str 'window {width: 300px;}')

[ -z "$action" ] && exit 1

if [ "$action" = "scale" ]; then
    newval=$(printf "%s (current)\n1.0\n1.25\n1.5\n2.0" "$scale" | rofi -dmenu -p "New scale for ${monitor_name} (e.g. 1.25)" -theme-str 'window {width: 300px;}')
    [ -z "$newval" ] && exit 1
    x=$(echo "${position}" | cut -dx -f1)
    new_pos="$(echo "$x / ${newval}" | bc)x$(echo "${position}" | cut -dx -f2)"
    hyprctl keyword monitor "$monitor_name,$resolution,$new_pos,$newval"
elif [ "$action" = "resolution" ]; then
    newval=$(printf "%s (current)\n1920x1080@60\n2560x1440@60\n3840x2160@60" "$resolution" | rofi -dmenu -p "New resolution for ${monitor_name} (e.g. 1920x1080@60)" -theme-str 'window {width: 400px;}')
    [ -z "$newval" ] && exit 1
    hyprctl keyword monitor "$monitor_name,$newval,$position,1"
fi

notify-send "Set ${monitor_name} with new option: $action: ${newval}"
