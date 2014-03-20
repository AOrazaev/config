#!/usr/bin/env bash

BACKUP_DIR=${HOME}/.config_backup
_PYTHONSTARTUP=${HOME}/.pythonstartup
_VIM=${HOME}/.vim
_VIMRC=${HOME}/.vimrc
_BASHRC=${HOME}/.bashrc
_BASH_PROFILE=${HOME}/.profile


. common.sh

function main() {
    mkdir -p ${BACKUP_DIR}
    info "You can find your current configuration backup in ${BACKUP_DIR}"

    configure_bash
    configure_vim
    configure_python
}


function safe_cp {
    rm -rf $2
    cp -r $1 $2 || {
        error "While execing \`cp -r $@\`"
        exit 1
    }
}


function backup() {
    info "Backup current configurations..."
    for f in $@; do
        if [ -e $f ]; then
            debug "Backup ${f}..."
            cp -r $f ${BACKUP_DIR}/
        fi
    done
}


function configure_bash() {
    H1 "Configuring BASH"

    backup ${_BASHRC} ${_BASH_PROFILE}

    info "Copyin configs..."
    safe_cp src/_profile ${_BASH_PROFILE}
    safe_cp src/_bashrc ${_BASHRC}
}


function configure_vim() {
    H1 "Configuring VIM"

    backup ${_VIM} ${_VIMRC}

    info "Copying configs..."
    safe_cp src/_vim ${_VIM}
    safe_cp src/_vimrc ${_VIMRC}

    info "Cloning vundle plugin..."
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle || \
        warn "Vundle already installed...\n"

    info "Installing bundle pluggin..."
    vim -c 'BundleInstall' -c 'q|q'
}


function configure_python() {
    H1 "Configuring Python"

    backup ${_PYTHONSTARTUP}

    info "Copying configs..."
    safe_cp src/_pythonstartup ${_PYTHONSTARTUP}
}

main
