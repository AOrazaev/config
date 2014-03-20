#!/usr/bin/env bash


# ==============================
# Logging helpers
# ==============================

_GREEN='\033[01;32m'
_GRAY='\033[00m'
_DARK='\033[30m'
_RED='\033[1;31m'

function _logging_printf() {
    level=$1
    DATE=`date +'%Y-%m-%d %H:%M:%S'`
    shift
    printf "${DATE} -- ${level} -- $@\n" 1>&2
}

function warn() {
    _logging_printf "${_RED}WARNING${_GRAY}" "$@"
}

function warning() {
    warn "$@"
}

function error() {
    _logging_printf "${_RED}ERROR${_GRAY}" "$@"
}

function debug() {
    _logging_printf "${_DARK}DEBUG${_GRAY}" "$@"
}

function info() {
    _logging_printf "${_GREEN}INFO${_GRAY}" "$@"
}

function header() {
    line="======================="
    info "$line> $@ <$line"
}

function H1() {
    header "$@"
}
