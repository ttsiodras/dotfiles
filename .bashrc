# I need color in my listings and prompts
#export LS_COLORS="di=34:ln=31"
export LS_COLORS="di=1"
alias l='ls -alF --color'
alias ls='ls --color'
export PS1='\n\[\e[32;1m\]\u@\h\[\e[37;1m\] \w\n\[\e[0m\]\$ '

# Much better manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;37m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Search manpages in this order of sections
export MANSECT=1,2,3,4,5,6,7,8

# Use lesspipe when opening files (filetype based decoding)
export LESSOPEN='|lesspipe.sh %s'

# Dear LucasArts, use my soft midi
export SCUMMVM_PORT=128:0

# The Editor
export EDITOR=vim

# Make terminals wrap their lines correctly after resizing
shopt -s checkwinsize

# Read lots of kernel data
alias dmesg='dmesg -s131072'

# Use color by default when grepping
alias grep='grep --color=auto'

# Dont want history? Uncomment this
#unset HISTFILE
export HISTSIZE=1000000
export HISTFILESIZE=1000000
shopt -s histappend

# I always need floating point accuracy when running bc
alias bc='bc -l'

# Quickly quit w3m pager
alias w3m='w3m -o confirm_qq=0'

# I need readline in all these
alias cmucl='rlwrap cmucl'
alias clisp='rlwrap clisp'
alias ocaml='rlwrap ocaml'
alias sbcl='rlwrap sbcl'

# For QT builds
export QMAKESPEC=linux-g++

# Reset X
alias xreset='xrandr -s 0 --screen 0'

# There's no way I can live with default VI
alias vi='vim'

# For Python help to work:
export PYTHONDOCS=/usr/share/doc/python/html/

# Python startup - use readline
export PYTHONSTARTUP=~/.pythonStartup

# Git helpers - I need to be able to TAB-select them all
export PATH=$PATH:/usr/lib/git-core

# Android dev stuff
#export PATH=$PATH:/opt/android-sdk-linux/platform-tools/:/opt/android-ndk-r6b-mine/bin/:/opt/android-ndk-r6b/:/opt/android-sdk-linux/tools/

# VI bindings
set -o vi

# OBSOLETE: migrated to .inputrc, to work for all readline applications
#
# ( See http://stackoverflow.com/questions/6839273/bash-readline-equivalent-of-escape-dot-in-vi-mode )
#
# bind -m vi-command ".":insert-last-argument
# bind -m vi-insert "\C-l.":clear-screen
# bind -m vi-insert "\C-a.":beginning-of-line
# bind -m vi-insert "\C-e.":end-of-line
# bind -m vi-insert "\C-w.":backward-kill-word

# Moved this section to .xinitrc (faster startup of my XTerms now)
#
# # Infinality fonts
# . /etc/profile.d/infinality-settings.sh
#
# # Fixup my XTerms, mostly
# if [[ $TERM == xterm* ]] ; then
#     xrdb -merge $HOME/.Xresources
#     xrdb -merge $HOME/.Xdefaults
# fi

# Fastest image viewer ever - start it zoomed
alias feh='feh -FZ'
alias r="sudo -i"
alias pwdx="pwd | xclip ; pwd | xclip -selection clipboard"

# Point the PATH to utilities I use every day ( https://github.com/ttsiodras/utils )
export PATH=~/bin:$PATH

# Setup SSH agent - is keychain available?
if keychain --version >/dev/null 2>&1 ; then
    # yes, and it's a better alternative, since it handles gpg too:
    eval $(keychain --quiet --eval)
else
    # Manual, error-prone way to setup SSH agent...
    env | grep SSH_CLIENT >/dev/null && {
        export SSH_AGENT_PID=$(pidof ssh-agent)
        export SSH_AUTH_SOCK=$(echo /tmp/ssh-*/*)
    }
fi

# Under X, and no keys? Add em up the first time we run.
if env | grep DISPLAY >/dev/null ; then
    ssh-add -l |& grep '/id_dsa' > /dev/null || {
        # Better to use 'pass' to add SSH agent keys, instead of plain...
        #  ssh-add
        $HOME/dotfiles/setupSshAgentKeysViaPass.sh
    }
fi

# For my mutt sessions - replies sent to little ARM server
# export REPLYTO=ttsiod@ttsiodras.verymad.net

# Make the CAPSLOCK key behave as a second CTRL - very useful on many keyboards
env | grep SSH_CLIENT >/dev/null || {
    setxkbmap -option ctrl:nocaps
}

# bash-completion for Dropbox
. $HOME/dotfiles/dropbox.sh

# OCaml-related stuff

# OPAM configuration
[ -e $HOME/.opam/opam-init/init.sh ] && {
    . /home/ttsiod/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
}

# Bug in current version of opam::utop - must clean up CAML_LD_LIBRARY_PATH
function utop()
{
    LIB=$(opam config var lib)
    export  CAML_LD_LIBRARY_PATH="$LIB/stublibs"
    BIN=$(opam config var bin)
    $BIN/utop
}

# Finally, load machine-specific specs
[ -f $HOME/.bashrc.local ] && . $HOME/.bashrc.local
