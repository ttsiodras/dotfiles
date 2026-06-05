#!/bin/bash
set -u
COOL=""
[ -d "$HOME/.password-store" ] && COOL=$(pass Home/SSH-Agent)

if [ -n "$COOL" ] ; then
    # Feed the passphrase to ssh-add via expect.
    /usr/bin/expect <<OEF
spawn ssh-add
expect "Enter passphrase for"
send "$COOL\n"
interact
OEF
else
    # No password store, or empty entry: fall back to an interactive prompt.
    ssh-add
fi
