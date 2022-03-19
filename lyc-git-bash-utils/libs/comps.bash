#! /bin/bash

# Completions.
#
# Can be run as an executable.
# Provides command completion for the "gbu" command.

# Copyright 2022 Yucheng Liu. GNU GPL3 license.
# GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt

# Inclusion flag.
_gbu_incl_libs_comps=1

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname $__file)

if [[ -z $_gbu_incl_libs_utils ]]; then
    source $__dir/utils.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

if [[ -z $_gbu_incl_libs ]]; then
    source $__dir/__init__.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

# "gbu" commands.
_gbu_cmds=\
"
clear-main-names create-dev create-rel dev-merge-rel help info init-repo list-main-names list-user-info
main-merge-rel merge-dev-updates merge-rel-updates pull-updates push-updates rel-merge-dev set-main-name
set-user-info show-graph tag-main update-feature update-patch
"

# "gbu" completion command.
_gbu_comp_cmd="complete -o default -W \"$_gbu_cmds\" gbu"
