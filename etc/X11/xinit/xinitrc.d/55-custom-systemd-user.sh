#!/bin/sh
# /etc/X11/xinit/xinitrc.d/55-custom-systemd-user.sh @ hortensia
# Last edited 2015-11-28
# Place here all custom user environment variables needed by systemd --user

systemctl --user import-environment DBUS_SESSION_ADRESS 

if which dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment DISPLAY XAUTHORITY
fi
