#!/bin/bash
# Idempotent: safe to re-run on any machine.
set -u
cd "$HOME" || exit 1

# Files we manage as symlinks into ~/dotfiles.
files=(.bashrc .bash_profile .profile .inputrc .commonrc .tmux.conf .xprofile .emacs .Xresources .xinitrc .pythonStartup .Xdefaults .screenrc)

# link_dotfile TARGET LINK
# Point LINK at TARGET, backing up or refusing to clobber anything unexpected
# already sitting at LINK. Idempotent: a link already aimed at TARGET is left
# alone. Handles four pre-existing states at LINK:
#   - the symlink we want         -> nothing to do
#   - a foreign/dangling symlink  -> back it up (or warn) before relinking
#   - a real file                 -> back it up (or warn) before relinking
#   - nothing                     -> just create the link
link_dotfile() {
    local target="$1" link="$2"
    local shown="~/${link#"$HOME"/}"             # tidy display for either caller

    # Already the symlink we want: nothing to back up, nothing to relink.
    [ "$(readlink "$link" 2>/dev/null)" = "$target" ] && return 0

    # Anything else already at this path gets preserved once before we relink.
    # -L catches symlinks (including dangling ones, which -e misses); -e catches
    # real files/dirs. Together they cover every non-empty state.
    if [ -L "$link" ] || [ -e "$link" ]; then
        if [ -e "$link.defaults" ] || [ -L "$link.defaults" ]; then
            # Something is here but a backup already exists, so we will not
            # clobber it. Leave it untouched and warn instead.
            echo "WARNING: $shown exists and $shown.defaults already exists; skipping symlink" >&2
            return 0
        fi
        mv "$link" "$link.defaults" || exit 1
    fi
    # ln -sfn replaces an old symlink in place and is a no-op when the link
    # already points where we want.
    ln -sfn "$target" "$link"
}

for f in "${files[@]}"; do
    link_dotfile "dotfiles/$f" "$f"
done

# Mirror ~/dotfiles/.config into ~/.config, file by file. Real directories are
# recreated under ~/.config so a directory can hold both repo-tracked links and
# machine-local files; only leaf files become symlinks. The fontconfig .arch /
# .debian variants are per-machine sources (not a live fonts.conf), so we skip
# anything that would not map directly to a live config path.
cfg_src="$HOME/dotfiles/.config"
if [ -d "$cfg_src" ]; then
    while IFS= read -r -d '' src; do
        rel="${src#"$cfg_src"/}"                 # path relative to .config
        case "$rel" in
            fontconfig/*.arch|fontconfig/*.debian) continue ;;  # per-machine variants
        esac
        dst="$HOME/.config/$rel"
        mkdir -p "$(dirname "$dst")" || exit 1
        link_dotfile "$src" "$dst"
    done < <(find "$cfg_src" -type f -print0)
fi

# Wire the shared git config into ~/.gitconfig (once). Absolute path so it
# resolves regardless of cwd; the included file lives in this repo and syncs.
shared="$HOME/dotfiles/.gitconfig-shared"
if ! git config --global --get-all include.path | grep -qxF "$shared"; then
    git config --global --add include.path "$shared"
fi
