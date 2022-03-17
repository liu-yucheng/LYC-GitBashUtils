#! /bin/bash

# "gbu create-dev" command executable.
#
# Can be executed directly.
# Finds the main branch name.
# Goes to the main branch.
# Tries to create a dev (development) branch.
# Goes to the dev branch.

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

if [[ -z $_gbu_incl_libs_defaults ]]; then
    source $__dir/../libs/defaults.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

__main() {
    local brief_usage="gbu create-dev"
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects 0 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nHelp: gbu help"
    local many_args_fmt="\"$brief_usage\" gets too many arguments\nExpects 0 arguments; Gets %s arguments\n"

    if [[ $# -lt 0 ]]; then
        printf "$few_args_fmt" "$#" >|/dev/stderr
        echo -e "$usage" >|/dev/stderr
        exit 1
    elif [[ $# -eq 0 ]]; then
        touch $_gbu_main_names_loc
        local main_names=$(cat $_gbu_main_names_loc)
        local main_name_list=()
        local ifs_backup=$IFS
        IFS=$'\n'

        while [[ 1 ]]; do
            local line
            read line

            if [[ $? -ne 0 ]]; then
                break
            fi

            main_name_list+=("$line")
        done <<<$main_names

        IFS=$ifs_backup
        local main_name=${main_name_list[0]}

        if [[ -z "$main_name" ]]; then
            local main_name=main
        fi

        (
            set -o xtrace # Turn command tracing on

            git checkout $main_name
            git branch dev
            git checkout dev
            git branch
        )

        exit 0
    else
        printf "$many_args_fmt" "$#" >|/dev/stderr
        echo -e "$usage" >|/dev/stderr
        exit 1
    fi
}

__main "$@"
