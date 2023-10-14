#!/usr/bin/env bash

DIR=$HOME/Desktop/wallpapers
PICS=($(find ${DIR} -maxdepth 1 -type f -exec basename {} \;))

RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

if [[ $(pidof swaybg) ]]; then
  pkill swaybg
fi

notify-send -i ${DIR}/${RANDOMPICS} "Wallpaper Changed" ${RANDOMPICS}
swaybg -m fill -i ${DIR}/${RANDOMPICS}
canberra-gtk-play -i window-attention
