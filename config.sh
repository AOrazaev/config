#!/usr/bin/env bash

BACKUP_DIR=${HOME}/.config_backup
_PYTHONSTARTUP=${HOME}/.pythonstartup
_VIM=${HOME}/.vim
_VIMRC=${HOME}/.vimrc
_BASHRC=${HOME}/.bashrc
_BASH_PROFILE=${HOME}/.profile


. logging.sh

function main() {
    rm -rf ${BACKUP_DIR}
    mkdir -p ${BACKUP_DIR}
    info "You can find your current configuration backup in ${BACKUP_DIR}"

    configure_bash
    configure_vim
    configure_python
}


function safe_cp {
    if [ -e "$2" ]; then
        debug "Backup ${2}..."
        backup -q -m $2
    fi
    cp -r $1 $2 || {
        error "While execing \`cp -r $@\`"
        exit 1
    }
}


function backup() {
    _cp='cp -r'
    _quiet=yes
    while [ "$1" == '-q' ] || [ "$1" == '-m' ]; do
        case $1 in
            '-q') _quiet='';;
            '-m') _cp='mv -f'
        esac
        shift
    done

    [ ! "${_quiet}" ] || info "Backup current configurations..."
    for f in $@; do
        if [ -e $f ]; then
            ${_cp} $f ${BACKUP_DIR}/
        fi
    done
}


function configure_bash() {
    H1 "Configuring BASH"

    info "Copyin configs..."
    safe_cp src/_profile ${_BASH_PROFILE}
    safe_cp src/_bashrc ${_BASHRC}
}


function configure_vim() {
    H1 "Configuring VIM"

    info "Copying configs..."
    safe_cp src/_vim ${_VIM}
    safe_cp src/_vimrc ${_VIMRC}

    info "Cloning vundle plugin..."
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle || \
        warn "Vundle already installed...\n"

    info "Installing bundle pluggins..."
    vim -c 'BundleInstall' -c 'q|q'

    if [ -e "${BACKUP_DIR}/.vim/view" ]; then
        info "Restoring .vim/view"
        cp -r ${BACKUP_DIR}/.vim/view ${_VIM}/
    fi
}


function configure_python() {
    H1 "Configuring Python"

    info "Copying configs..."
    safe_cp src/_pythonstartup ${_PYTHONSTARTUP}
}

main
