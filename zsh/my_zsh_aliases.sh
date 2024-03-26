######################################
############# GENERAL ################
######################################
DT_ROOT_PATH=/Users/jean/Documents/CODE/dotfiles

echo "zsh aliases custom"

alias lrt='ls -lrt'               # sort by date
alias l.='ls -d .* --color=auto'  # ls only .file
alias mv='mv -i'
alias rm='rm -i'

alias emacs='emacs -nw'       #emacs no graphics
alias tree='tree -L 2'

alias cdd='cd `ls -dt */ | head -1`'              # cd the latest directory created
alias cdt='cd ~/TOOLS/'                           # cd the tools directory
alias CDD='cd ${DT_ROOT_PATH}/'                   # alias CDD='cd /users/pourroy/TOOLS/dotfiles'


# alias which='(alias; declare -f) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot' # TODO

# pwd that can take argument : pwd | pwd File1 File2
mypwd() { [ $# -eq 0 ] && pwd || (for arg in "$@"; do [ -e "$arg" ] && echo "$(realpath "$arg")" || echo "Pwd error Invalid arg: $arg"; done); }
alias pwd='mypwd "$@"'



#Change directory, even if its a file, then ls...
cd() {
    if [ -f "$1" ]; then
        cd "$(dirname "$1")"
    else
        builtin cd "$@" && echo -n "  --> " && mypwd && ls --color=auto; 
    fi
}


#Print the content of the last created file (and its name) in the current directory, sorry for the alias name...
#            --  list only file - latest file -  cat with filename -- 
alias caca='ls -tp | grep -v /  | head -1     | xargs tail -v -n +1'
# same but keep track of the file
alias CACA='ls -tp | grep -v / | head -1 | xargs tail -f -v -n +1'

# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

alias ipr='ip route | column -t'
alias ips='ip --brief address show'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias cp='cp -i'

# HPE way
alias WHO='whoami ; echo -e "\e[1m\e[38;2;1;169;130m\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\e[0m\n\e[1m\e[38;2;1;169;130m\u2588\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u2588\u0020\e[0m\n\e[1m\e[38;2;1;169;130m\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\e[0m\n\e[1mHewlett Packard\e[0m\nEnterprise\n"'

# User specific aliases and functions

#GREP find in file : GREP . string
GREP() {
    grep --color=auto -nRHIi --no-messages $2 $1 # TODO bash version
    command grep --color=auto -nRHIi --no-messages "$2" "$1" | column -t -s ":"
}

#FIND find filename : FIND . filename
FIND() {
    find "$1" -iname "*$2*" | GREP_COLOR='1;31' grep --color=always -i "$2"
}


#Look for $1 in all the man pages available on the system
MAN (){
  IFS=':' read -r -a array <<< $(manpath)
  for element in "${array[@]}"
  do
    grep -rlIi $1 $element
  done
}

######################################
########### BASH vs ZSH ##############
######################################
BASH_TYPE=`ps -p$$ -o cmd="",comm="",fname="" 2>/dev/null | sed 's/^-//' | grep -oE '\w+' | head -n1`
# TODO
# if [[ $BASH_TYPE == "bash" ]]
# then
#     hist (){
#          if [ $# -eq 0 ]
#          then
#             echo "Max 1000 lines..."
#             history 1000 | cut -c 8-
#          else
#             history | cut -c 8- | grep $1
#          fi
#     }
# elif [[ $BASH_TYPE == "zsh" ]]
# then
#     hist (){
#          if [ $# -eq 0 ]
#          then
#             echo "Max 1000 lines..."
#             history -1000 | cut -c 8-
#          else
#             history 0 | cut -c 8- | grep $1
#          fi
#     }
# fi

######################################
########## MAC vs LINUX ##############
######################################
if [[ $OSTYPE == 'darwin'* ]]; then
    alias ls="ls -Gh"
else
    alias ls='ls --color=auto -h' # color + size in MB GB...
fi

######################################
#############   SSH  ################
######################################
alias ssgre="ssh pourroy@16.16.184.23"
alias sslumi="ssh pourroy@lumi.csc.fi"
