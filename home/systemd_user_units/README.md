
# Systemd user unit files


__Systemd__ offers users the ability to manage services under the user's control with a per-user systemd instance, enabling users to start, stop, enable, and disable their own units. 

Please visit [systemd/user on Archlinux wiki](https://wiki.archlinux.org/index.php/Systemd/User) for more details.

## How it works

1. a user __dbus__ session is first started at init. As of systemd 226-1 and dbus 1.10.0-3, the D-Bus user session is started automatically. 

2. *console.target* services are started at init. These services do not need X11
    + ssh-agent.service
    + urxvtd.service
    + devmon.service
    
3. **X** session is started this way from virtual console : `$ xinit`
    
4. *wm.target* services are started. These services need X11 to be run first
    + mate-settings-daemon.service
    + kalu.service
    + adb.service
    + psd.service
    
wm.target is started by adding a line in **xinitrc**:

`systemctl --user start wm.target`
    
Each service file is started and enabled running these commands:
```
$ systemctl --user start MyService
$ systemctl --user enable MyService
```

### dbus
Only two debus sessions: **pid1** and **user**
```
113:dbus 491  1  0 Feb11 ?  00:00:00 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation
120:gabx 619  575  0 Feb11 ? 00:00:01 /usr/bin/dbus-daemon --config-file=/etc/dbus-1/session.conf
```

### Xorg
_Xorg is now run by user_
```
128:gabx      1547  1546  1 Feb11 tty1     00:52:02 /usr/bin/Xorg.bin -nolisten tcp vt1
```

## Configuration
__Systemd__ user session starts with fresh environment variables. These variable 
values are returned by this command:
```
$ systemctl --user show-environment
```

Some services need aditional variables to be passed to __systemctl__. The needed
variables are stored in a file `/etc/systemd/user.conf.d/MyService.conf`. 


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

    
