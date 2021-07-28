# dotfiles
Helpfull configuration files 


# Installation

Add the following code to your original /home/.basrc and set the correct path to PATH_DOT_FILE
```bash
PATH_DOT_FILE=/path/to/dotfile
test -s $PATH_DOT_FILE/bashrc_custom       && . $PATH_DOT_FILE/bashrc_custom       || true
test -s $PATH_DOT_FILE/bash_aliases_custom && . $PATH_DOT_FILE/bash_aliases_custom || true
```

Create the following symbolic links 
```bash
PATH_DOT_FILE=/path/to/dotfile
ln -s $PATH_DOT_FILE/emacs_custom     .emacs
ln -s $PATH_DOT_FILE/tmux.conf_custom .tmux.conf
```

Edit the SERVER-NAME for the shell prompt in bashrc_custom
```bash
export PS1='\[\033[00;32m\]SERVER-NAME-\h\[\033[00m\]:\[\033[00;35m\]\W \[\033[00m\](\[\033[00;36m\]`git branch 2>/dev/null|cut -f2 -d\* -s | sed -e "s/ //"`\[\033[00m\]) $ '
```
