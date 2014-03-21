#!/usr/bin/env bash

. config_vars.sh
. logging.sh


function main() {
    generate_diffs
}


function question() {
    printf "${1} \n"
    select yn in 'yes' 'no'; do
        case $yn in
            yes) return 0;;
            no) return 1;;
        esac
    done
}


function _diff() {
    local_file=${1}
    src_file=${2}
    if [[ "${local_file}" == src/_* ]]; then
        local_file=${2}
        src_file=${1}
    fi

    diff -q ${local_file} ${src_file} >/dev/null || {
        H1 "Changes in ${local_file}:"
        diff ${src_file} ${local_file}
        if question "${_GREEN}Apply changes?${_GRAY}"; then
            cp ${local_file} ${src_file}
        fi
    }
}


function generate_diffs() {
    _diff ${_VIMRC} src/_vimrc
    _diff ${_BASHRC} src/_bashrc
    _diff ${_BASH_PROFILE} src/_profile
    _diff ${_PYTHONSTARTUP} src/_pythonstartup
    warn "If you have any changes in ${_VIM} update.sh will not see it."
    warn "Please update it manualy."
    warn "Or do not touch it. Configure your vim using ${_VIMRC} and vundle."
}


main

