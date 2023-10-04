#!/bin/bash
cd
mv .bashrc .bashrc.defaults || exit 1
mv .profile  .profile.defaults || exit 1
ln -s dotfiles/.bashrc 
ln -s dotfiles/.bash_profile 
ln -s dotfiles/.profile 
ln -s dotfiles/.inputrc 
ln -s dotfiles/.commonrc 
ln -s dotfiles/.tmux.conf 
ln -s dotfiles/.tmux.conf
