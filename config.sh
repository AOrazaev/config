#!/usr/bin/env bash

. config_vars.sh
. logging.sh


function main() {
    rm -rf ${BACKUP_DIR}
    mkdir -p ${BACKUP_DIR}
    info "You can find your current configuration backup in ${BACKUP_DIR}"

    configure_bash
    configure_vim
    configure_python
}


function safe_cp() {
    if [ -e "$2" ]; then
        debug "Backup ${2}..."
        backup -q -m $2
    fi
    cp -r $1 $2 || {
        error "While execing \`cp -r $@\`"
        exit 1
    }
}

function need_update() {
    if [ ! -e ${1} ] || [ ! -e ${2} ]; then
        return 0
    fi

    if ! diff ${1} ${2} > /dev/null; then
        return 0
    fi

    return 1
}

function safe_cp_if_need() {
    if need_update ${1} ${2}; then
        safe_cp ${1} ${2}
    else
        debug "Do not need update ${1} -> ${2}"
    fi
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
    safe_cp_if_need src/_profile ${_BASH_PROFILE}
    safe_cp_if_need src/_bashrc ${_BASHRC}
}


function configure_vim() {
    H1 "Configuring VIM"
    if ! need_update src/_vimrc ${_VIMRC}; then
        debug "VIM already configured."
        return 0
    fi

    info "Copying configs..."
    safe_cp src/_vim ${_VIM}
    safe_cp src/_vimrc ${_VIMRC}

    info "Cloning vundle plugin..."
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || \
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
    safe_cp_if_need src/_pythonstartup ${_PYTHONSTARTUP}
}

main
