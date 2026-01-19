# 1. Définitions XDG (Standards)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"

# C'est une bonne place pour SSH_AUTH_SOCK car elle dépend de XDG_RUNTIME_DIR
# (Cette variable est fournie par le système au login)
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

# 2. Configuration Zsh (Indispensable ici pour que Zsh trouve sa config)
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# 3. Applications par défaut
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="wezterm"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# 4. Configuration Neovim (Correction de votre ligne)
export NVIM_APPNAME="nvimLazyvim"

# 5. Configuration PATH (TexLive)
# Note : on vérifie si le dossier existe pour éviter des erreurs silencieuses
if [ -d "/usr/local/texlive/2024/bin/x86_64-linux" ]; then
    export PATH="/usr/local/texlive/2024/bin/x86_64-linux:$PATH"
    export MANPATH="/usr/local/texlive/2024/texmf-dist/doc/man:$MANPATH"
    export INFOPATH="/usr/local/texlive/2024/texmf-dist/doc/info:$INFOPATH"
fi

# 6. Configuration Ruby / Gems
# Attention : exécuter une commande ici peut ralentir le login très légèrement
if command -v gem >/dev/null 2>&1; then
    export GEM_HOME="$(gem env user_gemhome)"
    export PATH="$PATH:$GEM_HOME/bin"
fi

# 7. Autres PATHs utilisateurs
export PATH="$PATH:$HOME/bin:$HOME/.cargo/bin"

# -----------------------------------------------------------
# IMPORT SYSTEMD (À la toute fin)
# On importe TOUT l'environnement défini ci-dessus vers systemd
# -----------------------------------------------------------
systemctl --user import-environment GNUPGHOME PATH
