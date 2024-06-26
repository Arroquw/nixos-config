#!/bin/sh

config="$HOME/.config/rofi/power.rasi"

shutdown=""
reboot=""
lock=""
suspend=""
logout=""

chosen="$(printf "%s\n%s\n%s\n%s\n%s\n" "$shutdown" "$reboot" "$lock" "$suspend" "$logout" | rofi -theme "$config" -p "$(uptime -p)" -dmenu -selected-row 2)"

execute () {
  # yad --title "Are you sure you want to $2?" --button "Yes":0 --button "No":1 --buttons-layout center --center --on-top --fixed --no_escape
  # exit=$?

  # if [ "$exit" -eq 0 ]; then
  #   $1
  # fi
  $1
}

case "$chosen" in
  "$shutdown")
    execute "systemctl poweroff" "shutdown"
  ;;
  "$reboot")
    execute "systemctl reboot" "reboot"
  ;;
  "$lock")
    execute "hyprlock" "lock"
  ;;
  "$suspend")
    execute "playerctl -a stop && systemctl suspend" "suspend"
  ;;
  "$logout")
    execute "kill -9 -1" "quit"
  ;;
esac
