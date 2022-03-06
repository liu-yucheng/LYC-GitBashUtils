#! /bin/bash

# Completion.
#
# Can be run as an executable.
# Provides command completion for the "gbu" command.

# Copyright 2022 Yucheng Liu. GNU GPL3 license.
# GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname ${__file})

if [[ -z $_gbu_incl_libs_utils ]]; then
    source $__dir/utils.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

if [[ -z $_gbu_incl_libs ]]; then
    source $__dir/__init__.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

__comp() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local gbu_cmds="clear-main-names create-dev create-rel dev-merge-rel help info init-repo list-main-names \
        list-user-info main-merge-rel merge-dev-updates merge-rel-updates pull-updates push-updates rel-merge-dev \
        set-main-name set-user-info show-graph tag-main update-feature update-patch"

    complete -o default -W "$gbu_cmds" gbu
}

__comp
