#!/bin/sh
#
# ~/.xinitrc
# Executed by startx (run your window manager from here)
# Last modified 2014-09-10
			
xset fp rehash &
# load my X resources
xrdb -merge $HOME/.config/urxvt/.urxvtrc &
						
# start desktop environment
exec i3 					




