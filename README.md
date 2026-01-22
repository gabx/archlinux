# Archlinux

My archlinux stuff. Mostly basic configuration files.



## home

`/home` folder contains per user configurations

As possible, most of configuration files use the **$XDG_HOME_DIR**, `~/.config`, environment variable

## File importance order
1. `~/.zshenv` is always read at the start. It only serves to tell **zsh** where to find specific files.
2. `~/.config/zsh/.zprofile` is read once at login. It defines variables, path, keyring.
3. `~/.config/zsh/.zshrc` is read whenever a new terminal window/tab is opened.
   

