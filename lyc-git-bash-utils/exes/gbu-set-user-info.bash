#! /bin/bash

# "gbu set-user-info" command executable.
#
# Can be executed directly.
# Sets the git user info.

# Copyright 2022-2025 Yucheng Liu. Under the GNU AGPL 3.0 license.
# GNU AGPL 3.0 license: https://www.gnu.org/licenses/agpl-3.0.txt .

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
    local brief_usage="gbu set-user-info <name> <email>"
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects 2 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nHelp: gbu help"
    local many_args_fmt="\"$brief_usage\" gets too many arguments\nExpects 2 arguments; Gets %s arguments\n"

    # local arg_list=("${@}") # Debug
    # declare -p arg_list # Debug

    if [[ $# -lt 2 ]]; then
        printf "$few_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    elif [[ $# -eq 2 ]]; then
        (
            set -o xtrace # Turn command tracing on

            git config --global --replace-all user.name "$1"
            git config --global --replace-all user.email "$2"
        )

        exit 0
    else
        printf "$many_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    fi
}

__main "$@"
