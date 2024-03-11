#!/bin/bash

# CONFIGURATION
DT_ROOT_PATH=$(pwd)
PATH_UTILS="$DT_ROOT_PATH/utils"
BASHRC_FILE="$HOME/.bashrc"
[ "$(uname)" == "Darwin" ] && BASHRC_FILE="$HOME/.bash_profile"
CFG_EMACS_PATH="$HOME/.emacs"
CFG_TMUX_PATH="$HOME/.tmux.conf"

# Initialization of install flags
declare -A is_installed=(
    [FZF]=false
    [TREE]=false
    [EMACS]=false
    [TMUX]=false
    [GDU]=false
    [HELLO]=false
    [XTHI]=false
)

install_fzf() {
    echo "Starting installation of fzf..."
    if ! command -v fzf &>/dev/null; then
        if git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" >/dev/null 2>&1; then
            if "$HOME/.fzf/install" --key-bindings --completion --update-rc >/dev/null 2>&1; then
                is_installed[FZF]=true
                echo "  ~ FZF installation completed successfully."
            else
                echo "  ~ An error occurred during the fzf installation script execution."
            fi
        else
            echo "  ~ Failed to clone the fzf repository. Please check your internet connection or git settings."
        fi
    else
        echo "  ~ FZF is already installed."
        is_installed[FZF]=true
    fi
}

# Add similar functions for TREE, EMACS, TMUX, GDU, HELLO, XTHI installations
# Example for TREE
install_tree() {
    echo "Starting installation of tree..."
    if command -v tree &>/dev/null; then
        echo "  ~ Tree is already installed."
        is_installed[TREE]=true
        return
    fi

    mkdir -p tmp && cp tree-2.0.4.tgz tmp && pushd tmp >/dev/null || {
        echo "  ~ Failed to create a temporary directory for the tree installation."
        return
    }
    tar zxvf tree-2.0.4.tgz >/dev/null || {
        echo "  ~ Failed to extract tree-2.0.4.tgz. Please check the archive."
        popd >/dev/null
        return
    }
    pushd tree-2.0.4 >/dev/null || {
        echo "  ~ Failed to enter the tree-2.0.4 directory."
        popd >/dev/null
        return
    }
    make >/dev/null 2>&1 || {
        echo "  ~ An error occurred during the 'make' process of tree."
        popd >/dev/null
        popd >/dev/null
        return
    }
    mkdir -p "$HOME/.local/bin" && cp tree "$HOME/.local/bin/" && is_installed[TREE]=true
    echo "  ~ Tree installation completed successfully."
    popd >/dev/null
    popd >/dev/null
    rm -rf tmp
}

# Example for EMACS linking
customize_emacs() {
    echo "Starting customization of Emacs configuration..."
    if ! command -v emacs &>/dev/null; then
        echo "  ~ Emacs is not installed."
        is_installed[EMACS]=false
        return
    fi

    if [ ! -f "$DT_ROOT_PATH/emacs_custom" ]; then
        echo "  ~ Custom Emacs configuration file does not exist at $DT_ROOT_PATH/emacs_custom."
        is_installed[EMACS]=false
        return
    fi

    if [ -f "$CFG_EMACS_PATH" ]; then
        mv "$CFG_EMACS_PATH" "${CFG_EMACS_PATH}.old"
        echo "  ~ Existing Emacs configuration backed up as ${CFG_EMACS_PATH}.old."
    fi

    ln -s "$DT_ROOT_PATH/emacs_custom" "$CFG_EMACS_PATH" && is_installed[EMACS]=true
    echo "  ~ Emacs configuration successfully customized."
}

# Example for TMUX linking
customize_tmux() {
    if command -v tmux &>/dev/null && [ -f "$DT_ROOT_PATH/tmux.conf_custom" ]; then
        [ -f "$CFG_TMUX_PATH" ] && mv "$CFG_TMUX_PATH" "${CFG_TMUX_PATH}.old"
        ln -s "$DT_ROOT_PATH/tmux.conf_custom" "$CFG_TMUX_PATH" && is_installed[TMUX]=true
    fi
}

# Function to perform additional bashrc customizations
customize_bashrc() {
    echo "Starting customization of .bashrc..."

    # Custom PS1 prompt with git branch
    if ! grep -q --fixed-strings "export PS1='\[\033[00;32m" "$BASHRC_FILE"; then
        echo "  ~ Adding custom PS1 prompt to $BASHRC_FILE..."
        echo "export PS1='\[\033[00;32m\]SERVER_NAME_CHANGE_ME-\h\[\033[00m\]:\[\033[00;35m\]\W \[\033[00m\]\[\033[00;36m\] $ \[\033[00m\]'" >>"$BASHRC_FILE"
        echo "  ~ Please update the server name. Opening $BASHRC_FILE in vi..."
        sleep 2
        vi "$BASHRC_FILE" +$
    else
        echo "  ~ Custom PS1 prompt already exists in $BASHRC_FILE."
    fi

    # Include custom files
    if ! grep -q "$DT_ROOT_PATH/bashrc_custom" "$BASHRC_FILE"; then
        echo "  ~ Adding source command for bashrc_custom to $BASHRC_FILE..."
        echo "test -s $DT_ROOT_PATH/bashrc_custom && . $DT_ROOT_PATH/bashrc_custom || true" >>"$BASHRC_FILE"
    else
        echo "  ~ bashrc_custom already sourced in $BASHRC_FILE."
    fi

    if ! grep -q "$DT_ROOT_PATH/bash_aliases_custom" "$BASHRC_FILE"; then
        echo "  ~ Adding source command for bash_aliases_custom to $BASHRC_FILE..."
        echo "test -s $DT_ROOT_PATH/bash_aliases_custom && . $DT_ROOT_PATH/bash_aliases_custom || true" >>"$BASHRC_FILE"
    else
        echo "  ~ bash_aliases_custom already sourced in $BASHRC_FILE."
    fi

    echo "  ~ .bashrc customization completed."
}

install_gdu() {
    echo "Starting installation of gdu..."
    if command -v gdu &>/dev/null; then
        echo "  ~ gdu is already installed."
        is_installed[GDU]=true
        return
    fi

    mkdir -p tmp && pushd tmp &>/dev/null || {
        echo "  ~ Failed to create or navigate to the temporary directory."
        return
    }
    if curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz &>/dev/null; then
        chmod +x gdu_linux_amd64
        mkdir -p "$HOME/.local/bin"
        cp gdu_linux_amd64 "$HOME/.local/bin/gdu" &&         is_installed[GDU]=true
        echo "  ~ gdu successfully installed."
    else
        echo "  ~ Failed to download or extract gdu. Please check your internet connection or the URL."
        is_installed[GDU]=false
    fi
    popd &>/dev/null
}

install_xthi() {
    echo "Starting installation of xthi_mpi..."
    if command -v xthi_mpi &>/dev/null; then
        echo "  ~ xthi_mpi is already installed."
        is_installed[XTHI]=true
        return
    fi

    if ! git clone https://github.com/ARCHER2-HPC/xthi >/dev/null 2>&1; then
        echo "  ~ Failed to clone xthi repository. Please check your internet connection or git settings."
        return
    fi

    echo "  ~ Repository cloned successfully."
    pushd xthi/src >/dev/null || {
        echo "  ~ Failed to enter the xthi/src directory."
        return
    }

    if ! make >/dev/null 2>&1; then
        echo "  ~ Compilation of xthi_mpi failed. Please check for required dependencies."
        popd >/dev/null
        return
    fi

    mkdir -p "$HOME/.local/bin"
    cp xthi_mpi xthi_mpi_mp "$HOME/.local/bin/"
    is_installed[XTHI]=true
    echo "  ~ xthi_mpi successfully compiled and installed."

    popd >/dev/null
}

# Function to install hello_jobstep
install_hello() {
    echo "Starting installation of hello_jobstep..."
    if command -v hello_jobstep &>/dev/null; then
        echo "  ~ hello_jobstep is already installed."
        is_installed[HELLO]=true
        return
    fi

    pushd "$DT_ROOT_PATH/tools" >/dev/null || {
        echo "  ~ Failed to navigate to $DT_ROOT_PATH/tools"
        return
    }
    if [ ! -d "hello_jobstep" ]; then
        echo "  ~ hello_jobstep directory does not exist in $DT_ROOT_PATH."
        popd >/dev/null
        return
    fi

    pushd hello_jobstep >/dev/null || {
        echo "  ~ Failed to enter the hello_jobstep directory."
        popd >/dev/null
        return
    }
    source ../utils/gpu_env.sh

    if ! make >/dev/null 2>&1; then
        echo "  ~ Compilation of hello_jobstep failed. Please check for required dependencies."
        popd >/dev/null
        popd >/dev/null
        return
    fi

    mkdir -p "$HOME/.local/bin"
    cp hello_jobstep "$HOME/.local/bin/"
    make clean
    is_installed[HELLO]=true
    echo "  ~ hello_jobstep successfully compiled and installed."

    popd >/dev/null
    popd >/dev/null
}

# Call installation and configuration functions
install_fzf
install_tree
install_xthi
# install_hello
install_gdu

customize_emacs
# customize_tmux
customize_bashrc

# Summary
echo "+ Summary of the installation: "
for key in "${!is_installed[@]}"; do
    printf "   - %-10s %s\n" $key ${is_installed[$key]}

done

echo "+ Please update: "
echo "   - MY_SLURM_*   in  ~/.bashrc"
echo "   - Module list  in  $DT_ROOT_PATH/utils/gpu_env.sh"
