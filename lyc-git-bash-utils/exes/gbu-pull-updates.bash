#! /bin/bash

# "gbu pull-updates" command executable.
#
# Pulls all branches from origin or a specified remote named $1.

# Copyright 2022 Yucheng Liu. GNU GPL3 license.
# GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname $__file)

if [[ -z $_gbu_incl_libs_utils ]]; then
    source $__dir/../libs/utils.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

if [[ -z $_gbu_incl_exes ]]; then
    source $__dir/__init__.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

__main() {
    local brief_usage="gbu pull-updates [<optional-remote>]"
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects 0<= count <=1 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nHelp: gbu help"
    local many_args_fmt="\"$brief_usage\" gets too many arguments\nExpects 0<= count <=1 arguments; Gets %s arguments\
        \n"

    if [[ $# -lt 0 ]]; then
        printf "$few_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    elif [[ $# -ge 0 && $# -le 1 ]]; then
        local remote_name=origin

        if [[ -n "$1" ]]; then
            local remote_name=$1
        fi

        (
            set -o xtrace # Turn command tracing on

            git pull --no-edit --autostash $remote_name "*:*"
        )

        exit 0
    else # elif [[ $# -gt 1 ]]; then
        printf "$many_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    fi
}

__main "$@"
