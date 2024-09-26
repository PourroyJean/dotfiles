######################################
############# GENERAL ################
######################################

alias ls='ls --color=auto'
alias lrt='ls -lrt'               # sort by date
alias l.='ls -d .* --color=auto'  # ls only .file
alias mv='mv -i'
alias rm='rm -i'

alias emacs='emacs -nw'       #emacs no graphics
alias tree='tree -L 2'

alias cdd='cd `ls -dt */ | head -1`'              # cd the latest directory created
alias cdt='cd ~/TOOLS/'                           # cd the tools directory
alias CDD='cd ${DF_ROOT_PATH}/'                   # cd ditfile directory

alias ipr='ip route | column -t'
alias ips='ip --brief address show'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias cp='cp -i'
alias cat='bat'

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

# top but only for me
alias TOP="top -u $(whoami)"

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



# HPE way
alias WHO='whoami ; echo -e "\e[1m\e[38;2;1;169;130m\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\u2584\e[0m\n\e[1m\e[38;2;1;169;130m\u2588\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u2588\u0020\e[0m\n\e[1m\e[38;2;1;169;130m\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\u2580\e[0m\n\e[1mHewlett Packard\e[0m\nEnterprise\n"'

# User specific aliases and functions

#GREP find in file : GREP . string
GREP() {
    # grep --color=always -nRHIi --no-messages $2 $1 # TODO bash version
    command grep --color=always -nRHIi --no-messages "$2" "$1" | column -t -s ":"
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

LS ()
{
    if [[ -d "$1" ]]; then
        du -sh "$1";
    else
        if [[ "$1" =~ ^[0-9]+$ ]]; then
            ls --color=auto -h -lS | head -n "$1";
        else
            ls --color=auto -h -lS | head -n 11;
        fi;
    fi
}


# Usage: hist [search_term]
#  - Without arguments, shows the last 30 commands. 
#  - With an argument, searches and displays the last 30 matches.
#  - R emove the first 30 caracters :  778  2024-03-29 17:26:29   ssh -X abc
hist (){
      echo "Max 30 lines : $1"
      if [ $# -eq 0 ]
      then
        history -30 | cut -c 30-
      else
        history | grep --color=always  $1 | tail -n 30
      fi
}
# fi

# CHMOD Function
# Changes the permissions of specified files to 'a+x'.
# Usage:
#   CHMOD pattern1 [pattern2 ...]
# Example:
#   CHMOD my_files_* another_pattern_*
CHMOD() {
    if [ "$#" -eq 0 ]; then
        echo "No files specified. Please provide a file pattern."
        return
    fi

    for file_pattern in "$@"; do
        files=$(ls -tp $file_pattern 2>/dev/null)
        
        if [ -z "$files" ]; then
            echo "No files found matching pattern: $file_pattern"
            continue
        fi

        for file in $files; do
            if [ ! -d "$file" ]; then
                echo "Change $file permissions to a+x? (Y/N): "
                read response
                if [[ "$response" =~ ^[Yy]$ ]]; then
                    chmod a+x "$file"
                    echo "Permissions changed for $file"
                else
                    echo "Permission change aborted for $file."
                fi
            fi
        done
    done
}


# Function: S
# Usage:
#   S [session_name]  - Attach to or create a screen session with the given name.
#                       If no session name is provided, defaults to "MY_SCREEN".
#   S ls              - List all active screen sessions using "screen -ls".
# Description:
#   This function helps manage screen sessions. If a session name is provided,
#   it will attach to an existing session with that name or create a new one if
#   it doesn't exist. If "ls" is provided as an argument, it lists all active
#   screen sessions.

S() {
    # If the first argument is "ls", run "screen -ls"
    if [ "$1" == "ls" ]; then
        screen -ls
        return
    fi

    # If a parameter is provided, use it as the session name; otherwise, use "MY_SCREEN"
    local session_name="${1:-MY_SCREEN}"

    # Check if the session exists
    if screen -list | grep -q "$session_name"; then
        # Attach to the existing session
        screen -x "$session_name"
    else
        # Create a new session with the given or default name
        screen -S "$session_name"
    fi
}


######################################
#############   SSH  ################
######################################
alias ssgre="ssh pourroy@16.16.184.124"
alias sslumi="ssh pourroy@lumi.csc.fi"
