#!/bin/bash
COOL=$(pass Home/SSH-Agent)
/usr/bin/expect <<OEF
spawn ssh-add
expect "Enter passphrase for"
send "$COOL\n"
interact
OEF
