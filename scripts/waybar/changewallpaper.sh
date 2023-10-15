#!/usr/bin/env bash

DIR=$HOME/Desktop/wallpapers
PICS=($(find -L ${DIR} -maxdepth 1 -type f -exec basename {} \;))
echo "PICS: ${PICS}" > /home/jusson/1.log

RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

if [[ $(pidof swaybg) ]]; then
  pkill swaybg
fi

notify-send -i ${DIR}/${RANDOMPICS} "Wallpaper Changed" ${RANDOMPICS}
swaybg -m fill -i ${DIR}/${RANDOMPICS}
canberra-gtk-play -i window-attention
