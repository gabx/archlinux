# Archlinux

My archlinux stuff. Mostly basic configuration files.

## etc

`/etc` folder contains system wide configurations.

## home

`/home` folder contains per user configurations

As possible, most of configuration files use the **$XDG_HOME_DIR**, `~/.config`, environment variable

## X environment

- window manager: [i3](https://wiki.archlinux.org/index.php/I3)
- file manager: [ranger](https://wiki.archlinux.org/index.php/Ranger) + [PCmanFM](https://wiki.archlinux.org/index.php/PCManFM)
- theme: started with `mate-settings-daemon` systemd service file
- mount: [udisk2](https://wiki.archlinux.org/index.php/Udisks)

## Kernel configuration

The kernel is a custom one built with [Arch Build System](https://wiki.archlinux.org/index.php/Kernels/Arch_Build_System).

Its config file aims at removing lots of unneeded stuffs and follows some security advices from [Kernsec](https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings)