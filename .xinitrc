#!/bin/bash

# Font rendering heaven
. /etc/profile.d/infinality-settings.sh

# My X11 settings
/usr/bin/xrdb -merge $HOME/.Xresources
/usr/bin/xrdb -merge $HOME/.Xdefaults

# Being able to lock is useful
/usr/bin/xscreensaver &

# Job requirements... meh
/usr/local/bin/skype &

# Make sure you launch your X11 with 'ssh-agent startx'
/usr/bin/xterm -e '/usr/bin/ssh-add' &

# Ctrl-space leads to easy search of tools
/usr/bin/launchy &

# Common GNOME/Xsel clipboard
# (...or you could just add these lines to a new file,
#  named, say, 40-autocutsel in the directory:
#    /etc/X11/xinit/xinitrc.d/
/usr/bin/autocutsel -fork &
/usr/bin/autocutsel -selection PRIMARY -fork &

# Lead on, window manager...
. /etc/X11/Xsession
#exec /usr/bin/icewm-session
#exec /usr/bin/lxsession
