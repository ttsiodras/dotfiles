# shellcheck disable=SC1091
#
# Generic prompt
# export PS1='\n\[\e[32;1m\]\u@\h\[\e[37;1m\] \w\n\[\e[0m\]\$ '
#
# Git-aware prompt aware
if [ -n "$PS1" ] ; then
    # But only set this is we are in an interactive shell (PS1 defined)
    # Otherwise we break SCP!
    [ -f /.dockerenv ] && MACHINE_TYPE="DOCKER " || MACHINE_TYPE=""
    export PS1='\n'"$MACHINE_TYPE"'\[\e[32;1m\]\u@\h\[\e[37;1m\] \w\n\[\e[0m\]\[$txtcyn\]${git_branch}\[${txtred}\]${git_dirty}\[$txtrst\]\$ '
fi

# Dont want history? Uncomment this
#unset HISTFILE
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTCONTROL=ignorespace
shopt -s histappend

# Make terminals wrap their lines correctly after resizing
shopt -s checkwinsize

# OBSOLETE: migrated to .inputrc, to work for all readline applications
#
# ( See http://stackoverflow.com/questions/6839273/bash-readline-equivalent-of-escape-dot-in-vi-mode )
#
# bind -m vi-command ".":insert-last-argument
# bind -m vi-insert "\C-l.":clear-screen
# bind -m vi-insert "\C-a.":beginning-of-line
# bind -m vi-insert "\C-e.":end-of-line
# bind -m vi-insert "\C-w.":backward-kill-word

# Instead of showing the options, just cycle through them
# e.g. with folders "Documents" and "Downloads"
#    cd D<tab>
# ...will now cycle through them.
# bind '"\t":menu-complete'


# Setup git-aware prompt
[ -f ~/dotfiles/git-prompt/main.sh ] && {
    export GITAWAREPROMPT=~/dotfiles/git-prompt/
    . "${GITAWAREPROMPT}/main.sh"
}

# Dont pollute the $HOME folder with .PROGNAME_history files
export RLWRAP_HOME=$HOME/.config/rlwrap
mkdir -p "${RLWRAP_HOME}"
export RLWRAP_EDITOR="vim '+call cursor(%L,%C)'"

# Finally, load common zsh/bash parts...
[ -f ~/.commonrc ] && . ~/.commonrc

# ...and machine-specific parts
[ -f ~/.bashrc.local ] && . ~/.bashrc.local

# Older way for fzf env var setup, but still exists in some of my machines
[ -f ~/.fzf.bash ] && . ~/.fzf.bash

# Cleanup duplicates from PATH
export PATH="$(echo "$PATH" | sed 's,:,\n,g' | awk '!a[$0]++' | tr '\n' ':' | sed 's,:$,,')"
