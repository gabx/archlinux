#!/bin/sh
#
# ~/.xinitrc
# Executed by startx (run your window manager from here)
# Last modified 2013-11-04


if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi


nvidia-settings --config=$HOME/.config/nvidia/.nvidia-settings-rc --l &			# load nvidia monitor settings
xset fp rehash &
xrdb -merge $HOME/.config/urxvt/.urxvtrc &						# load my X resources
#exec i3 -V >> ~/.config/i3/i3log 2>&1 &						# log i3 output
exec mate-session 		        						# starts the window manager




