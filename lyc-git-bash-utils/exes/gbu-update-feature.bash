#! /bin/bash

# "gbu update-feature" command executable.
#
# Invokes the "gbu dev-merge-rel" executable.
# Goes to the dev branch.
# Creates a feature branch called $1.
# Goes to the feature branch.
# Adds and commits all changes.
# Logs the feature commit message, $2.
# Goes back to the dev branch.
# Deletes the feature branch.

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

__main() {
    local brief_usage="gbu update-feature <feature-branch-name> <feature-commit-message>"
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects 2 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nHelp: gbu help"
    local many_args_fmt="\"$brief_usage\" gets too many arguments\nExpects 2 arguments; Gets %s arguments\n"

    # local arg_list=("${@}") # Debug
    # declare -p arg_list # Debug

    if [[ $# -lt 2 ]]; then
        printf "$few_args_fmt" "$#" >|/dev/stderr
        echo -e "$usage" >|/dev/stderr
        exit 1
    elif [[ $# -eq 2 ]]; then
        $__dir/gbu-dev-merge-rel.bash

        (
            set -o xtrace # Turn command tracing on

            git checkout dev
            git branch $1
            git checkout $1
            git add -A
            git status
            git commit -m "$2"
            git checkout dev
            git merge $1 --no-ff -m "dev branch merged feature branch $1"
            git branch -d $1
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
