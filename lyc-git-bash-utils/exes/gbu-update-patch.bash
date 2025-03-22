#! /bin/bash

# "gbu update-patch" command executable.
#
# Goes to the rel branch.
# Creates a patch branch called $1.
# Goes to the patch branch.
# Adds and commits all changes.
# Logs the patch commit message, $2.
# Goes back to the rel branch.
# Deletes the patch branch.

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
    local brief_usage="gbu update-patch <patch-branch-name> <patch-commit-message>"
    local aliases="update-rel-patch"
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects 2 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nAliases: $aliases\nHelp: gbu help"
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

            git checkout rel
            git branch $1
            git checkout $1
            git add -A
            git status
            git commit -m "$2"
            git checkout rel
            git merge $1 --no-ff -m "rel branch merged patch branch $1"
            git branch -d $1
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
