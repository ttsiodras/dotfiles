#!/bin/bash
# HOME=/home/ttsiod
export PATH=/usr/bin:$PATH

# Font rendering heaven
[ -f /etc/profile.d/infinality-settings.sh ] && . /etc/profile.d/infinality-settings.sh

# My X11 settings
xrdb -merge $HOME/.Xresources
xrdb -merge $HOME/.Xdefaults

# Being able to lock is useful
# xscreensaver &

# Job requirements... meh
#skype &

# Make sure you launch your X11 with 'ssh-agent startx'
#xterm -e 'eval $(keychain --quiet --eval) ; /usr/bin/ssh-add' &

# Common GNOME/Xsel clipboard
# (...or you could just add these lines to a new file,
#  named, say, 40-autocutsel in the directory:
#    /etc/X11/xinit/xinitrc.d/
# autocutsel -fork &
# autocutsel -selection PRIMARY -fork &

# Set backlight for MBAir and stop the stupid udisks Arch service
#
# ( sleep 2 ; echo 750 | sudo tee /sys/class/backlight/intel_backlight/brightness ; sudo systemctl stop udisks2.service ) &

# CAPS LOCK must be set to ESCAPE (Vim)
setxkbmap -option ctrl:nocaps

# For i3, Alt is a horrendous choice if you are Greek.
# So set mod3 to the Cmd key.
# And to avoid xmodmap failing, remove Super_L from other mod...
#
# xmodmap -e "remove mod1 = Super_L"
# xmodmap -e "remove mod2 = Super_L"
# xmodmap -e "remove mod3 = Super_L"
# xmodmap -e "remove mod4 = Super_L"
# xmodmap -e "remove mod5 = Super_L"
# xmodmap -e "add mod3 = Super_L"

# A terminal is always nice - esp. for i3 and a bad 'mod' setting...
# xterm &

# Lead on, window manager...
# Make sure whichever of the lines below you choose actually points to existing files

#. /etc/X11/Xsession
exec /usr/bin/i3
#exec /usr/bin/icewm-session
#exec /usr/bin/lxsession
