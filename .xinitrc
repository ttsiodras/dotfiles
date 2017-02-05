# Font rendering heaven
. /etc/profile.d/infinality-settings.sh

# My X11 settings
/usr/bin/xrdb -merge $HOME/.Xresources
/usr/bin/xrdb -merge $HOME/.Xdefaults
/usr/bin/xmodmap $HOME/.xmodmap

# Being able to lock is useful
# /usr/bin/xscreensaver &

# Job requirements... meh
# /usr/local/bin/skype &

# Make sure you launch your X11 with 'ssh-agent startx'
/usr/bin/xterm -e 'eval $(keychain --quiet --eval) ; /usr/bin/ssh-add' &

# Common GNOME/Xsel clipboard
# ...or you could just add these lines to a new file:
#  /etc/X11/xinit/xinitrc.d/40-autocutsel 
# /usr/bin/autocutsel -fork &
# /usr/bin/autocutsel -selection PRIMARY -fork &

# Lead on, window manager...
# Make sure whichever of the lines below you choose actually points to existing files

#. /etc/X11/Xsession
#exec /usr/bin/icewm-session
exec /usr/bin/lxsession
