#!/bin/bash
# HOME=/home/ttsiod
export PATH=/usr/bin:$PATH

# X Fonts
XFT_SETTINGS="
Xft.antialias:  1
Xft.autohint:   0
Xft.dpi:        96
Xft.hinting:    1
Xft.hintstyle:  hintfull
Xft.lcdfilter:  lcddefault
Xft.rgba:       rgb
" 
echo "$XFT_SETTINGS" | xrdb -merge > /dev/null 2>&1

# My X11 settings
xrdb -merge $HOME/.Xresources
xrdb -merge $HOME/.Xdefaults

# Being able to lock is useful
# xscreensaver &

# Job requirements... mehS
#skype &

# Make sure you launch your X11 with 'ssh-agent startx'
#xterm -e '/usr/bin/ssh-add' &

# Common GNOME/Xsel clipboard
# (...or you could just add these lines to a new file,
#  named, say, 40-autocutsel in the directory:
#    /etc/X11/xinit/xinitrc.d/
# autocutsel -fork &
# autocutsel -selection PRIMARY -fork &

# Set backlight and stop the stupid udisks Arch service
#
# ( sleep 2 ; echo 57000 | sudo tee /sys/class/backlight/intel_backlight/brightness ; sudo systemctl stop udisks2.service ) &

# CAPS LOCK must be set to ESCAPE (Vim)
setxkbmap -option ctrl:nocaps us

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

# Nice background in space
#/usr/local/bin/xlivebg &
#disown

# Lead on, window manager...
# Make sure whichever of the lines below you choose actually points to existing files

#/usr/local/bin/xlivebg &
#disown

#. /etc/X11/Xsession
exec /usr/bin/i3
#exec /usr/bin/icewm-session
#exec /usr/bin/lxsession
