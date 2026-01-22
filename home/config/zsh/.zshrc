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

# --- CONFIGURATION INTELLIGENTE DISTROBOX ---

# 1. Si on est dans une Distrobox, on change le prompt

# 2. Correction DBUS (pour éviter l'erreur rouge au démarrage)
# On ne lance dbus-update que si on est sur l'hôte (PAS dans la box)
#if [[ -z "$DISTROBOX_ENTERED" && $EUID -ne 0 ]]; then
#     # Remplacez votre ancienne ligne dbus par celle-ci si elle existe ailleurs
#     dbus-update-activation-environment --systemd --all
#fi
# On ne lance la commande QUE si dbus... existe
# -----------------------------------------------------
# CONFIGURATION PROMPT DISTROBOX (VERSION FINALE)
# -----------------------------------------------------

# Fonction qui s'exécute AVANT d'afficher le prompt
set_distrobox_prompt() {
    # On vérifie si la variable CONTAINER_ID est remplie
    if [[ -n "$CONTAINER_ID" ]]; then
        # On force la variable PROMPT de Zsh
        # %n = user (vert), %~ = dossier
        PROMPT="%F{green}%n@%F{red}$CONTAINER_ID%F{reset} ➤➤ %~ %# "
    fi
}

# On ajoute cette fonction à la liste des choses à faire avant le prompt
precmd_functions+=(set_distrobox_prompt)


# -----------------------------------------------------
# CORRECTION ERREURS (DBUS/SYSTEMCTL)
# -----------------------------------------------------
# On vérifie l'existence de la commande avant de lancer
# 2. Que nous ne sommes PAS root ($UID n'est pas 0)
if [[ $UID -ne 0 ]] && command -v dbus-update-activation-environment > /dev/null 2>&1; then
    dbus-update-activation-environment --systemd --all
fi




