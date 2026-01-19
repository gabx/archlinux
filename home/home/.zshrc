# File: ~/.zshrc @ magnolia
# Last modified: 2015-03-03                           

# source zsh start-up file initzsh if it exists
if [[ -e "$HOME/.config/zsh/.initzsh" ]]; then
. "$HOME/.config/zsh/.initzsh"
fi

# R silencieux en mode interactif
function r() {
  R --quiet "$@"
}

# Démarrage automatique de Gnome Keyring
if [ -n "$DESKTOP_SESSION" ]; then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

# enable sudo + graphical app in CLI ex: # sudo gedit
# xhost +SI:localuser:root
# xhost +local:
#xhost +SI:localuser:root allows the root user to access the running X server. The current X server is indicated by the DISPLAY environment variable. xhost +local: does the same for every user, so the root line is not of much use.
# https://askubuntu.com/questions/877820/what-are-xhost-and-xhost-si

# import user env variables to systemd. Similar to systemctl --user import-environment
dbus-update-activation-environment --systemd --all