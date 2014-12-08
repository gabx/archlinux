#!/bin/sh
#
# ~/.xinitrc
# Executed by startx (run your window manager from here)
# Last modified 2014-12-10


# source ~/.xprofile by startx
[ -f ~/.xprofile ] && source ~/.xprofile


			
xset fp rehash &
# load my X resources
xrdb -merge $HOME/.config/urxvt/.urxvtrc &

# Start the notification daemon.
# dunst &

# make some cleaning
rm -rf $HOME/.cache/chromium
rm -rf $HOME/.cache/thumbnails
rm -rf $HOME/.cache/fontconfig

# Vacuuming SQLite databases
find $HOME/.mozilla/ \( -name "*.sqlite" \) -execdir sqlite3 {} "vacuum" \;

						
# start desktop environment
exec i3


					




