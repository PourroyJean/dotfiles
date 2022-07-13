#!/bin/bash

# CONFIGURATION
PATH_DOT_FILE=`pwd`
CFG_EMACS_PATH=~/.emacs
CFG_TMUX_PATH=~/.tmux.conf

is_INSTALL_FZF=true

echo "test -s $PATH_DOT_FILE/bashrc_custom       && . $PATH_DOT_FILE/bashrc_custom       || true" >> ~/.bashrc
echo "test -s $PATH_DOT_FILE/bash_aliases_custom && . $PATH_DOT_FILE/bash_aliases_custom || true" >> ~/.bashrc



# We check if the file already exists: we save it as backup.old
if [[ -f "$CFG_EMACS_PATH" ]]; then
    mv $CFG_EMACS_PATH "${CFG_EMACS_PATH}.old"
fi
ln -s $PATH_DOT_FILE/emacs_custom     $CFG_EMACS_PATH


if [[ -f "$CFG_TMUX_PATH" ]]; then
    mv $CFG_TMUX_PATH "${CFG_TMUX_PATH}.old"
fi
ln -s $PATH_DOT_FILE/tmux.conf_custom $CFG_TMUX_PATH


#FZF - https://github.com/junegunn/fzf#using-git
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


vi $PATH_DOT_FILE/bashrc_custom #EDIT SERVER-NAME
