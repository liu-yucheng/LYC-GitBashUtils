#! /bin/bash

# "gbu tag-main" command executable.
#
# Goes to the main branch.
# Tags the latest commit of the main branch as tag $1.
# Goes to the rel branch.

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

if [[ -z $_gbu_incl_libs_defaults ]]; then
    source $__dir/../libs/defaults.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

__main() {
    local brief_usage="gbu tag-main <tag-name>"
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects 1 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nHelp: gbu help"
    local many_args_fmt="\"$brief_usage\" gets too many arguments\nExpects 1 arguments; Gets %s arguments\n"

    if [[ $# -lt 1 ]]; then
        printf "$few_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    elif [[ $# -eq 1 ]]; then
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
            git tag $1 $main_name # Commit the latest commit of the main branch
            git checkout rel
            git branch
        )

        exit 0
    else
        printf "$many_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    fi
}

__main "$@"
