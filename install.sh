#!/bin/bash

# CONFIGURATION
PATH_DOT_FILE=`pwd`
BASHRC_FILE=~/.bashrc
# BASHRC_FILE=~/.bash_profile  #For Mac
CFG_EMACS_PATH=~/.emacs
CFG_TMUX_PATH=~/.tmux.conf

#FLAG
is_FZF_installed=false
is_TREE_installed=false
is_EMACS_installed=false
is_TMUX_installed=false
is_GDU_installed=false
is_HELLO_installed=false

#We export the PS1 prompt from the original bashrc file, 
#so the server name modification doesn't appear in git
if ! grep -q --fixed-strings "export PS1='\[\033[00;32m" $BASHRC_FILE ; then
  echo "export PS1='\[\033[00;32m\]SERVER_NAME_CHANGE_ME-\h\[\033[00m\]:\[\033[00;35m\]\W \[\033[00m\](\[\033[00;36m\]`git branch 2>/dev/null|cut -f2 -d\* -s | sed -e "s/ //"`\[\033[00m\]) $ '" >> $BASHRC_FILE
  echo "Please update the server name, will open vi..."
  sleep 2
  vi $BASHRC_FILE +$
fi


#ADD THE TWO CUSTOME FILES TO THE EXISTING ONE
#Check if already updated with our custom files      -- before sourcing the file we test if it exists
grep -q $PATH_DOT_FILE/bashrc_custom       $BASHRC_FILE || echo "test -s $PATH_DOT_FILE/bashrc_custom       && . $PATH_DOT_FILE/bashrc_custom       || true" >> $BASHRC_FILE
grep -q $PATH_DOT_FILE/bash_aliases_custom $BASHRC_FILE || echo "test -s $PATH_DOT_FILE/bash_aliases_custom && . $PATH_DOT_FILE/bash_aliases_custom || true" >> $BASHRC_FILE

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
  echo "tmux is not installed, and won't be"
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


#-- hello_jobstep --
#check https://code.ornl.gov/olcf/hello_jobstep/-/tree/master
if ! [ -x "$(command -v hello_jobstep)" ]; then
    echo "Installing hello_jobstep command : ";
    cd hello_jobstep
    source gpu_env.sh
    make
    [ -d ~/.local/bin ] || mkdir -p ~/.local/bin
    cp hello_jobstep ~/.local/bin/
    cd ..
    echo "Please add .local/bin/ to your PATH ..."
    PATH=.local/bin/:$PATH
fi
[ -x "$(command -v hello_jobstep)" ] && is_HELLO_installed=true

#-- GDU --
if ! [ -x "$(command -v gdu)" ]; then
    echo "Installing gdu command : ";
    [ -d tmp ] || mkdir tmp
    cd tmp
    curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz
    chmod +x gdu_linux_amd64
    [ -d ~/.local/bin ] || mkdir -p ~/.local/bin
    cp gdu_linux_amd64 ~/.local/bin/gdu
    cd ..
    echo "Please add .local/bin/ to your PATH ..."
    PATH=.local/bin/:$PATH
fi
[ -x "$(command -v gdu)" ] && is_GDU_installed=true

echo "+ Summary of the installation : "
echo "   - fzf       $is_FZF_installed"
echo "   - tree      $is_TREE_installed"
echo "   - emacs     $is_EMACS_installed"
echo "   - tmux      $is_TMUX_installed"
echo "   - gdu       $is_TMUX_installed"
echo "   - hello     $is_HELLO_installed"


