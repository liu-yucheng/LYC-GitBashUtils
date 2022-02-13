#! /bin/bash

# "gbu set-main-name" command executable
#
# Can be executed directly.
# Changes the main branch name.
# Adds the new main branch name to the record.
# Ensures that the record has no duplicate elements.
# Makes the name the first place and use it as the new main branch name.

# Copyright 2022 Yucheng Liu. GNU GPL3 license.
# GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname ${__file})

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
    local brief_usage="gbu set-main-name <new-main-name>"
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects 1 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nHelp: gbu help"
    local many_args_fmt="\"$brief_usage\" gets too many arguments\nExpects 1 arguments; Gets %s arguments\n"

    if [[ $# -lt 1 ]]; then
        printf "$few_args_fmt" "$#" >|/dev/stderr
        echo -e "$usage" >|/dev/stderr
        exit 1
    elif [[ $# -eq 1 ]]; then
        touch $_gbu_main_names_loc
        local main_names_lines=$(cat $_gbu_main_names_loc)
        local -a main_names
        local ifs_backup=$IFS
        IFS=$'\n'

        while [[ 1 ]]; do
            local line
            read line

            if [[ $? -ne 0 ]]; then
                break
            fi

            main_names+=("$line")
        done <<<$main_names_lines

        IFS=$ifs_backup
        echo "Old default branch name: ${main_names[0]}"

        local name_used=0
        local name_idx=0

        for idx in ${!main_names[@]}; do
            if [[ "${main_names[idx]}" == "$1" ]]; then
                local name_used=1
                local name_idx=$idx
            fi
        done

        if [[ $name_used -ne 0 ]]; then
            local main_names=(
                "${main_names[name_idx]}"
                "${main_names[@]::name_idx}"
                "${main_names[@]:name_idx+1}"
            )
        else
            local main_names=(
                "$1"
                "${main_names[@]}"
            )
        fi

        echo "New default branch name: ${main_names[0]}"
        printf "%s\n" "${main_names[@]}" >|$_gbu_main_names_loc

        (
            set -o xtrace # Turn command tracing on

            cat $_gbu_main_names_loc
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
