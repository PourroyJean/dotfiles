# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH_CUSTOM="${DT_ROOT_PATH}/zsh"
export ZSH="$HOME/.oh-my-zsh"             # Path to your oh-my-zsh installation. TODO portable ?


########### HISTORY SETINGS ############
setopt INC_APPEND_HISTORY   # This option appends each command to the history file as it is executed.
setopt HIST_IGNORE_DUPS     # This option does not enter command lines into the history list if they are duplicates of the previous event.
unsetopt EXTENDED_HISTORY   # This option disables the recording of duration for each history entry.
HIST_STAMPS="%F %T "        # Set the format of timestamps in history : 2024-03-26 14:44:13
HISTSIZE=9000000            # This sets the number of commands to remember in the command history.
SAVEHIST=9000000            # This sets the number of commands to store in the history file.
HISTFILE=~/.zsh_history     # This sets the file where the command history is saved. The tilde (~) represents the home directory.


########### GENERAL SETINGS ############

export EDITOR='emacs'       # Preferred editor for local and remote sessions
setopt autocd nomatch       # The 'autocd' option allows you to change to a directory just by typing its name. 
setopt nomatch              # The 'nomatch' option prevents an error when a pattern does not match any files.
unsetopt beep               # This option disables the terminal bell.
bindkey -e                  # This sets up 'emacs' style line editing.


# ALIASES
test -s ${ZSH_CUSTOM}/my_zsh_aliases.sh     && . ${ZSH_CUSTOM}/my_zsh_aliases.sh     || true 
test -s ${ZSH_CUSTOM}/my_zsh_aliases_hpc.sh && . ${ZSH_CUSTOM}/my_zsh_aliases_hpc.sh || true 


# PROMPT PS1 STYLE :
fpath+=${ZSH_CUSTOM}/plugins/pure
autoload -U promptinit; promptinit
prompt pure                            # DL dans plugins. Voir https://github.com/sindresorhus/pure
prompt_newline=$(echo -n "\u200B")     # I prefer a one liner version

# Path to your oh-my-zsh installation.
zstyle ':omz:update' mode disabled                     # Disable automatic updates
DISABLE_MAGIC_FUNCTIONS="true"                         # Pasting URLs and other text is messed up.
ENABLE_CORRECTION="true"                               # Enable command auto-correction.


# Should be at the end of the file
plugins=(zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh


#FZF CTRL + R configuration :
export FZF_CTRL_R_OPTS="\
--border sharp \
--height 40% \
--cycle \
--prompt='Recherche> ' \
--pointer='→' \
--color='dark,fg:magenta' \
--margin=3%,3%,8%,2% \
--layout default"

# TODO voir ce que fait l'installeur de fzf pour pas avoir de doublon
eval "$(fzf --zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
