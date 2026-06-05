#!/bin/bash
# Idempotent: safe to re-run on any machine.
set -u
cd "$HOME" || exit 1

# Files we manage as symlinks into ~/dotfiles.
files=(.bashrc .bash_profile .profile .inputrc .commonrc .tmux.conf .xprofile .emacs .Xresources .xinitrc .pythonStartup .Xdefaults .screenrc)

for f in "${files[@]}"; do
    # Already the symlink we want: nothing to back up, nothing to relink.
    [ "$(readlink "$f" 2>/dev/null)" = "dotfiles/$f" ] && continue

    # Back up a pre-existing real file once, so ln never destroys it silently.
    # Only a regular file (not a symlink) is worth saving, and only if we have
    # not already saved one. This guard keeps re-runs from clobbering a good
    # backup with whatever happens to be there now.
    if [ -e "$f" ] && [ ! -L "$f" ]; then
        if [ -e "$f.defaults" ]; then
            # A real file is here but a backup already exists, so we will not
            # clobber it. Leave it untouched and warn instead.
            echo "WARNING: ~/$f is a real file and ~/$f.defaults already exists; skipping symlink" >&2
            continue
        fi
        mv "$f" "$f.defaults" || exit 1
    fi
    # ln -sfn replaces an old symlink in place and is a no-op when the link
    # already points where we want.
    ln -sfn "dotfiles/$f" "$f"
done

# Wire the shared git config into ~/.gitconfig (once). Absolute path so it
# resolves regardless of cwd; the included file lives in this repo and syncs.
shared="$HOME/dotfiles/.gitconfig-shared"
if ! git config --global --get-all include.path | grep -qxF "$shared"; then
    git config --global --add include.path "$shared"
fi
