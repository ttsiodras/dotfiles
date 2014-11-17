# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [ $HOST = "home" ] ; then
    # Poor Atom330 takes 3 sec to start a shell with my work plugins...
    plugins=()
else
    plugins=(git svn python npm screen web-search)
fi
source $ZSH/oh-my-zsh.sh

# User configuration

# export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#
# TTSIOD additions
#

# Finally, load common zsh/bash parts...
[ -f $HOME/.commonrc ] && . $HOME/.commonrc

# ...and machine-specific parts
[ -f $HOME/.zshrc.local ] && . $HOME/.zshrc.local

# Oh, and up arrow must leave the cursor at end of line

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search

#
# ZSH doesn't care about the .inputrc mappings - so I repeat my readline
# bindings here (did the same for bash and posted it to Reddit some time ago)
#
#   http://www.reddit.com/r/vim/comments/r38nd/if_you_use_vimode_under_bash_and_you_miss_escdot/
#
bindkey -M viins "\e." insert-last-word

bindkey -M viins "jk" vi-cmd-mode

bindkey -M viins "^l" clear-screen
bindkey -M viins "^a" beginning-of-line
bindkey -M viins "^e" end-of-line
bindkey -M viins "^r" history-incremental-pattern-search-backward
bindkey -M viins "^s" history-incremental-pattern-search-forward
bindkey -M viins "^p" up-line-or-history
bindkey -M viins "^n" down-line-or-history
bindkey -M viins "^w" backward-kill-word
bindkey -M viins "\e[3~" delete-char
bindkey -M viins "\eOH" beginning-of-line
bindkey -M viins "\eOF" end-of-line

bindkey -M vicmd "^l" clear-screen
bindkey -M vicmd "^a" beginning-of-line
bindkey -M vicmd "^e" end-of-line
bindkey -M vicmd "^r" history-incremental-pattern-search-backward
bindkey -M vicmd "^s" history-incremental-pattern-search-forward
bindkey -M vicmd "^p" up-line-or-history
bindkey -M vicmd "^n" down-line-or-history
bindkey -M vicmd "^w" backward-kill-word
bindkey -M vicmd "\e[3~" delete-char
bindkey -M vicmd "\eOH" beginning-of-line
bindkey -M vicmd "\eOF" end-of-line

# Timeout to switch to vi command code - set to 0.1
# DISABLED - it breaks 'jk'
# export KEYTIMEOUT=1

# The prompt I am used to - maximum work area left
precmd() {
    echo
    echo $fg_bold[green]$USER@$HOST $fg[white]`pwd`
}
export PS1=$'%}${ret_status}%{$fg_bold[green]%}%p%{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
