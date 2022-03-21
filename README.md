# dotfiles
Helpfull configuration files 


# Installation

Run the following commands and edit the SERVER-NAME for the shell prompt:

```bash
git clone https://github.com/PourroyJean/dotfiles.git
cd dotfiles/
PATH_DOT_FILE=`pwd`
echo "test -s $PATH_DOT_FILE/bashrc_custom       && . $PATH_DOT_FILE/bashrc_custom       || true" >> ~/.bashrc
echo "test -s $PATH_DOT_FILE/bash_aliases_custom && . $PATH_DOT_FILE/bash_aliases_custom || true" >> ~/.bashrc
ln -s $PATH_DOT_FILE/emacs_custom     ~/.emacs
ln -s $PATH_DOT_FILE/tmux.conf_custom ~/.tmux.conf
vi $PATH_DOT_FILE/bashrc_custom #EDIT SERVER-NAME
```
