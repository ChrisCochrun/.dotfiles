#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Mail : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x

# Available Styles
# >> Styles Below Only Works With "rofi-git(AUR)", Current Version: 1.5.4-76-gca067234
#
# blurry	blurry_full		kde_simplemenu		kde_krunner		launchpad
# gnome_do	slingshot		appdrawer			appfolder		column
# row		row_center		screen				row_dock		row_dropdown


if [ $(hostname) = "chris-linuxlaptop" ]; then
    style="blurry-hidpi"
    #echo "this is hidpi"
else 
    style="blurry"
    #echo "this is not hidpi"
fi

rofi -no-lazy-grab -show drun -modi drun,window,calc,ssh,run,emoji -theme launchers-git/"$style".rasi
