#! /bin/bash

# "gbu init-repo" command executable.
#
# Can be executed directly.
# Runs "git init" in the current repository.
# Creates an empty README.md file in the repository.
# Runs "git add" on the README.md file.
# Makes an initial commit in the current repository.
# Invokes the "gbu create-rel" command executable.
# Invokes the "gbu create-dev" command executable.

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
    local brief_usage="gbu init-repo"
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects 0 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nHelp: gbu help"
    local many_args_fmt="\"$brief_usage\" gets too many arguments\nExpects 0 arguments; Gets %s arguments\n"

    if [[ $# -lt 0 ]]; then
        printf "$few_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    elif [[ $# -eq 0 ]]; then
        (
            set -o xtrace # Turn command tracing on

            git init
        )

        git log >>/dev/null 2>&1

        if [[ $? -ne 0 ]]; then
            (
                set -o xtrace # Turn command tracing on

                touch ./README.md
                git add ./README.md
                git commit -m "Initial commit; Added README"
            )
        fi

        $__dir/gbu-create-rel.bash
        $__dir/gbu-create-dev.bash
        exit 0
    else
        printf "$many_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    fi
}

__main "$@"
