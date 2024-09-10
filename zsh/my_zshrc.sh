
export ZSH_CUSTOM="${DF_ROOT_PATH}/zsh"     # Will automatically source all .zsh file in this folder : aliases for example... TODO c'est faux ?
export ZSH=${DF_ROOT_PATH}/OhMyZsh          # Path to your Oh My Zsh installation installed with ZSH=$DF_ROOT_PATH/OhMyZsh sh install_ohmyzsh.sh

export PATH=$HOME/bin:/usr/local/bin:$PATH          # If you come from bash you might have to change your $PATH.
export DF_PATH_TO_UTILS="${DF_ROOT_PATH}/utils"     # utils contains slurm partition settings, gpu env module...

########### ALIASES SOURCING ####################
source ${ZSH_CUSTOM}/my_zsh_aliases.zsh
source ${ZSH_CUSTOM}/my_zsh_aliases_hpc.zsh



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


# fpath+=$DF_ROOT_PATH/zsh/plugins/pure
# fpath+=$DF_ROOT_PATH/zsh/plugins/zsh-completions/src

# autoload -U promptinit; promptinit
# prompt pure



# PROMPT PS1 STYLE :
# fpath+=${ZSH_CUSTOM}/plugins/pure
# fpath+=(/home/x_pourroj/dotfiles/zsh/plugins/pure)
# fpath+=(/home/x_pourroj/TEST_ZSH_PURE_ONLY/pure)
# autoload -U promptinit; promptinit
# prompt pure

# echo $fpath
# autoload -U promptinit
# promptinit
# :
# autoload -U promptinit; promptinit

# autoload -U promptinit; promptinit
# autoload -Uz promptinit
# promptinit

# prompt pure                                 # DL dans plugins. Voir https://github.com/sindresorhus/pure
# prompt_newline=$(echo -n "\u200B")        # I prefer a one liner version, not sure after all

# Path to your oh-my-zsh installation.
zstyle ':omz:update' mode disabled          # Disable automatic updates
DISABLE_MAGIC_FUNCTIONS="true"              # Pasting URLs and other text is messed up.
ENABLE_CORRECTION="true"                    # Enable command auto-correction.


# source this before fzfc
# plugins=(zsh-autosuggestions zsh-syntax-highlighting colored-man-pages)
plugins=()
source $ZSH/oh-my-zsh.sh


################################################     FZF     ############################################
# FZF - CTRL + R configuration :
export FZF_CTRL_R_OPTS="\
--border sharp \
--height 60% \
--cycle \
--prompt='ctrl+y to copy cmd > ' \
--pointer='→' \
--color='dark,fg:magenta' \
--margin=3%,3%,8%,2% \
--layout default \
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' \
"

# FZF - CTRL+T option : preview with bat
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} | head -500'"

# This should be done by fzf install directly in the ~.zshrc file
# eval "$(fzf)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export PS1='%1~%# '


