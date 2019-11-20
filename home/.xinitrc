#!/bin/sh
#
# ~/.xinitrc
# Read by xinit and its wrapper startx (run your window manager from here)
# Last modified 2019-11-20
# https://www.askapache.com/linux/rxvt-xresources/


if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# source ~/.xprofile 
[ -f ~/.xprofile ] && . ~/.xprofile 

# adjust dpi
#xrandr --dpi 168 

# Remove the specified font path from Xorg's list of known font paths
xset -fp /usr/share/fonts/75dpi/  
xset -fp /usr/share/fonts/100dpi/ 
xset fp rehash 

# load my X resources
[ -f $HOME/.config/urxvt/.urxvtrc ] && 
xrdb -merge $HOME/.config/urxvt/.urxvtrc 


# Disable DPMS and turn off screen blanking
xset s off -dpms

# Use gnome keyring alone
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK


# make some cleaning
exec profile-cleaner f &
exec profile-cleaner t &


# start wm.target
systemctl --user start wm.target &
						
# start desktop environment 
exec i3 



					




