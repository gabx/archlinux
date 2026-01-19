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