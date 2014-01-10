# Blatantly stolen (highest praise!) from:
# https://github.com/ariofrio/dotfiles/blob/master/.bashrc.d/completion/dropbox.sh

# bash completion for dropbox.py

_dropbox()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    COMMANDS="status help puburl stop running start filestatus ls autostart exclude"
    OPTS="-i --install -l --list -a --all"
    if [ $COMP_CWORD -eq 1 ]; then
        completions="$COMMANDS" #TODO: check.
    elif [ $COMP_CWORD -eq 2 ]; then
        first="${COMP_WORDS[1]}"
        case "$first" in
            autostart) completions="y n";;
            exclude) completions="list add remove";;
            *) return 1;;
        esac
    else
        return 1
    fi
    COMPREPLY=( $( compgen -W "$completions" -- $cur ))
    return 0
}
complete -o default -F _dropbox dropbox.py
complete -o default -F _dropbox dropbox
complete -o default -F _dropbox db
