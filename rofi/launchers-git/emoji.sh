#!/usr/bin/env bash

if [ $(hostname) = "chris-linuxlaptop" ]; then
    style="laptop"
    #echo "this is hidpi"
else 
    style="desktop"
    #echo "this is not hidpi"
fi

rofi -no-lazy-grab -show emoji -modi emoji -theme launchers-git/"$style".rasi
