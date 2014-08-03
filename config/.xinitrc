#!/bin/sh
#
# ~/.xinitrc
# Executed by startx (run your window manager from here)
# Last modified 2014-08-03


# load nvidia monitor settings
nvidia-settings --config=$HOME/.config/nvidia/.nvidia-settings-rc --l &			
xset fp rehash &
# load my X resources
xrdb -merge $HOME/.config/urxvt/.urxvtrc &

						
# start desktop environment
exec i3 					




