#!/bin/bash
# Idempotent: safe to re-run on any machine.
set -u
cd "$HOME" || exit 1

# Back up the distro defaults once (only if not already backed up).
for f in .bashrc .profile; do
    if [ -e "$f" ] && [ ! -L "$f" ] && [ ! -e "$f.defaults" ]; then
        mv "$f" "$f.defaults" || exit 1
    fi
done

# Symlink dotfiles into $HOME. ln -sfn replaces an existing/old symlink
# in place and is a no-op when the link already points where we want.
for f in .bashrc .bash_profile .profile .inputrc .commonrc .tmux.conf; do
    ln -sfn "dotfiles/$f" "$f"
done

# Wire the shared git config into ~/.gitconfig (once). Absolute path so it
# resolves regardless of cwd; the included file lives in this repo and syncs.
shared="$HOME/dotfiles/.gitconfig-shared"
if ! git config --global --get-all include.path | grep -qxF "$shared"; then
    git config --global --add include.path "$shared"
fi
