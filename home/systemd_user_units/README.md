
# Systemd user unit files


__Systemd__ offers users the ability to manage services under the user's control with a per-user systemd instance, enabling users to start, stop, enable, and disable their own units. 

Please visit [systemd/user on Archlinux wiki](https://wiki.archlinux.org/index.php/Systemd/User) for more details.

## How it works

* a user __dbus__ session is first started

* *console.target* services are started. These services do not need X11
    + gpg-agent
    + ssh-agent
    + tmux
    + urxvtd
    
* *wm.target* services are started. These services need X11 to be run first
    + mate-settings-daemon
    
Each service file is started and enabled running these commands:
```
$ systemctl --user start MyService
$ systemctl --user enable MyService
```

## Configuration


__Systemd__ user session starts with fresh environment variables. These variable 
values are returned by this command:
```
$ systemctl --user show-environment
```

Some services need aditional variables to be passed to __systemctl__. The needed
variables are stored in a file `~/.config/systemd/user@.service.d/env.conf`. It is a list of blank separated keys in the form `VARIABLE=value`.

*N.B: the path and name of this file is your choice.*

This line has to be added in your shell startup file:
```
xargs systemctl --user set-environment < ~/.config/systemd/user@.service.d/env.conf
```

This way, variable values will be parsed to __systemd__

## fixing issues

```
$ systemctl --user status
```
return the list of user services (loaded, inactive or failed)

```
$ systemd-cgls
```
recursively shows the contents of the selected Linux control group hierarchy in a 
tree

    