# export PS1='\n\[\e[32;1m\]\u@\h\[\e[37;1m\] \w\n\[\e[0m\]\$ '
export PS1='\n\[\e[32;1m\]\u@\h\[\e[37;1m\] \w\n\[\e[0m\]\[$txtcyn\]${git_branch}\[${txtred}\]${git_dirty}\[$txtrst\]\$ '

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

# Setup git-aware prompt
export GITAWAREPROMPT=$HOME/dotfiles/git-prompt/
. "${GITAWAREPROMPT}/main.sh"

# bash-completion for Dropbox
. $HOME/dotfiles/dropbox.sh

# Finally, load common zsh/bash parts...
[ -f $HOME/.commonrc ] && . $HOME/.commonrc

# ...and machine-specific parts
[ -f $HOME/.bashrc.local ] && . $HOME/.bashrc.local
