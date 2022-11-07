#!/bin/bash

# CONFIGURATION
PATH_DOT_FILE=`pwd`
CFG_EMACS_PATH=~/.emacs
CFG_TMUX_PATH=~/.tmux.conf

#FLAG
is_FZF_installed=false
is_TREE_installed=false
is_EMACS_installed=false
is_TMUX_installed=false

#ADD THE TWO CUSTOME FILES TO THE EXISTING ONE
#Check if already updated with our custom files      -- before sourcing the file we test if it exists
grep -q $PATH_DOT_FILE/bashrc_custom       ~/.bashrc || echo "test -s $PATH_DOT_FILE/bashrc_custom       && . $PATH_DOT_FILE/bashrc_custom       || true" >> ~/.bashrc
grep -q $PATH_DOT_FILE/bash_aliases_custom ~/.bashrc || echo "test -s $PATH_DOT_FILE/bash_aliases_custom && . $PATH_DOT_FILE/bash_aliases_custom || true" >> ~/.bashrc

# -- EMACS --
if [ -x "$(command -v emacs)" ]; then
  # We check if the file already exists: we save it as backup.old
  if [[ -f "$CFG_EMACS_PATH" ]]; then
      mv $CFG_EMACS_PATH "${CFG_EMACS_PATH}.old"
  fi
  ln -s $PATH_DOT_FILE/emacs_custom     $CFG_EMACS_PATH
  is_EMACS_installed=true
else
  echo "emacs is not installed"
fi


# -- TMUX --
if [ -x "$(command -v tmux)" ]; then
  # We check if the file already exists: we save it as backup.old
  if [[ -f "$CFG_TMUX_PATH" ]]; then
     mv $CFG_TMUX_PATH "${CFG_TMUX_PATH}.old"
  fi
  ln -s $PATH_DOT_FILE/tmux.conf_custom $CFG_TMUX_PATH
  is_TMUX_installed=true
else
  echo "tmux is not installed"
fi


# -- FZF --
#Check https://github.com/junegunn/fzf#using-git
if ! [ -x "$(command -v fzf)" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi
[ -x "$(command -v fzf)" ] && is_FZF_installed=true


#-- TREE --
if ! [ -x "$(command -v tree)" ]; then
    echo "Installing tree command : ";
    [ -d tmp ] || mkdir tmp
    cd tmp
    wget https://mama.indstate.edu/users/ice/tree/src/tree-2.0.4.tgz
    tar zxvf tree-2.0.4.tgz
    cd tree-2.0.4/
    make
    [ -d ~/.local/bin ] || mkdir -p ~/.local/bin
    cp tree ~/.local/bin/
    cd ../..
    echo "Please add .local/bin/ to your PATH ..."
    PATH=.local/bin/:$PATH
fi
[ -x "$(command -v tree)" ] && is_TREE_installed=true


echo "+ Summary of the installation : "
echo "   - fzf       $is_FZF_installed"
echo "   - tree      $is_TREE_installed"
echo "   - emacs     $is_EMACS_installed"
echo "   - tmux      $is_TMUX_installed"

emacs $PATH_DOT_FILE/bashrc_custom #EDIT SERVER-NAME


