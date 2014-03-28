#!/usr/bin/env bash

. logging.sh


USR_LOCAL=${HOME}/.usr_local
VIM_CONFIGURE_OPTIONS="--enable-pythoninterp --enable-python3interp"
VIM_MAKE_OPTIONS="-j8"
VIM_INSTALL_OPTIONS="DESTDIR=${USR_LOCAL}"


function get_vim_srcs() {
    H1 "Downloading vim sources"
    mkdir -p ${USR_LOCAL}/srcs
    pushd ${USR_LOCAL}/srcs
    [ -e vim ] || hg clone https://vim.googlecode.com/hg/ vim || \
        {
            error "You shuld install mercurial on host for fetch vim sources."
            exit 1;
        }
    cd vim
    hg pull
    hg update
    popd
}


function build_vim() {
    pushd ${USR_LOCAL}/srcs/vim

    H1 "Configuring vim"
    info "Options: ${VIM_CONFIGURE_OPTIONS}"
    ./configure ${VIM_CONFIGURE_OPTIONS}

    H1 "Building vim"
    make ${VIM_MAKE_OPTIONS}

    H1 "Installing vim"
    info "Options: ${VIM_INSTALL_OPTIONS}"
    make install ${VIM_INSTALL_OPTIONS}

    echo "export VIMRUNTIME=${USR_LOCAL}/usr/local/share/vim/vim74/" \
        >> ${HOME}/.local_environment
}


function main() {
    get_vim_srcs
    build_vim
}


main

