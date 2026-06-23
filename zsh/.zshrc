# File: ~/.zshrc @ magnolia
# Last modified: 2015-03-03                           

# source zsh start-up file initzsh if it exists
source "$ZDOTDIR/.initzsh"

# R silencieux en mode interactif
function r() {
  R --quiet "$@"
}

# avoid issue with * (glob)
setopt NO_NOMATCH

# Démarrage automatique de Gnome Keyring
#if [ -n "$DESKTOP_SESSION" ]; then
#   eval $(gnome-keyring-daemon --start)
#    export SSH_AUTH_SOCK
#fi

# enable sudo + graphical app in CLI ex: # sudo gedit
# xhost +SI:localuser:root
# xhost +local:
#xhost +SI:localuser:root allows the root user to access the running X server. The current X server is indicated by the DISPLAY environment variable. xhost +local: does the same for every user, so the root line is not of much use.
# https://askubuntu.com/questions/877820/what-are-xhost-and-xhost-si

# import user env variables to systemd. Similar to systemctl --user import-environment
# Lancer dbus uniquement si l'utilisateur N'EST PAS root
#if [[ $EUID -ne 0 ]]; then
#    dbus-update-activation-environment --systemd --all
#fi


# -----------------------------------------------------
# CONFIGURATION PROMPT DISTROBOX (VERSION FINALE)
# -----------------------------------------------------

set_distrobox_prompt() {
    # Sécurité : On vérifie que la variable existe ET qu'on est vraiment dans un conteneur
    if [[ -n "$CONTAINER_ID" && -f /run/.containerenv ]]; then
        PROMPT="%F{green}%n@%F{red}$CONTAINER_ID%F{reset} ➤➤ %~ %# "
    fi
}

# On ajoute la fonction à la liste d'exécution
precmd_functions+=(set_distrobox_prompt)


# -----------------------------------------------------
# CORRECTION ERREURS (DBUS/SYSTEMCTL)
# -----------------------------------------------------
# On vérifie l'existence de la commande avant de lancer
# 2. Que nous ne sommes PAS root ($UID n'est pas 0)
if [[ $UID -ne 0 ]] && command -v dbus-update-activation-environment > /dev/null 2>&1; then
    dbus-update-activation-environment --systemd --all
fi

unsetopt chaselinks


