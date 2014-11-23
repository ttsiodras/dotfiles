#!/bin/bash
if [ -d $HOME/.password-store ] ; then
    COOL=$(pass Home/SSH-Agent)
/usr/bin/expect <<OEF
spawn ssh-add
expect "Enter passphrase for"
send "$COOL\n"
interact
OEF
else
    ssh-add
fi
