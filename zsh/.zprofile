# --- 1. Applications par défaut ---
export TERMINAL="wezterm"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# --- 2. Gestion du Keyring (Fix SSH/Git) ---
# Remplace l'ancien SSH_AUTH_SOCK statique par le dynamique
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# --- 3. Configuration des PATHs ---

# A. TexLive (Optimisé : une seule vérification)
if [ -d "/usr/local/texlive/2025/bin/x86_64-linux" ]; then
    export PATH="/usr/local/texlive/2025/bin/x86_64-linux:$PATH"
    export MANPATH="/usr/local/texlive/2025/texmf-dist/doc/man:$MANPATH"
    export INFOPATH="/usr/local/texlive/2025/texmf-dist/doc/info:$INFOPATH"
fi

# taskwarrior
export TASKRC="$HOME/.config/task/taskrc"

# ajout claude qui est dans $HOME/local/bin
export PATH="$HOME/.local/bin:$PATH"

# B. Ruby / Gems
if command -v gem >/dev/null 2>&1; then
    export GEM_HOME="$(gem env user_gemhome)"
    export PATH="$PATH:$GEM_HOME/bin"
fi

# C. Binaires utilisateurs & Rust
export PATH="$PATH:$HOME/bin:$HOME/.cargo/bin"

# --- 4. Intégration Systemd ---
# Important pour que les launchers graphiques voient le bon PATH
if command -v systemctl >/dev/null 2>&1; then
    systemctl --user import-environment PATH SSH_AUTH_SOCK
fi

export CLAUDE_CODE_OAUTH_TOKEN="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"
