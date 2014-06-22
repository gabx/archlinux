#!/bin/sh
#
# ~/.xinitrc
# Executed by startx (run your window manager from here)
# Last modified 2014-03-25


#setxkbmap -model pc104 -layout ch -variant fr &
nvidia-settings --config=$HOME/.config/nvidia/.nvidia-settings-rc --l &			# load nvidia monitor settings
xset fp rehash &
xrdb -merge $HOME/.config/urxvt/.urxvtrc &						# load my X resources

exec i3 					




