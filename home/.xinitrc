#!/bin/sh
#
# ~/.xinitrc
# Executed by startx (run your window manager from here)
# Last modified 2014-12-10


# source ~/.xprofile 
[ -f ~/.xprofile ] && . ~/.xprofile 

# adjust dpi
xrandr --dpi 168 

#hide mouse coursor when it isn't used
unclutter -root -visible &
			
xset fp rehash 

# load my X resources
[ -f $HOME/.config/urxvt/.urxvtrc ] && xrdb -merge $HOME/.config/urxvt/.urxvtrc 


# make some cleaning
rm -rf $HOME/.cache/chromium 
rm -rf $HOME/.cache/thumbnails 
rm -rf $HOME/.cache/fontconfig 

# Vacum SQLite databases
find $HOME/.mozilla/ \( -name "*.sqlite" \) -execdir sqlite3 {} "vacuum" \; 

# start wm.target
systemctl --user start wm.target

						
# start desktop environment
exec i3



					




