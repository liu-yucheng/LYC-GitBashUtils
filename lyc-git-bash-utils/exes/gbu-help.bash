#! /bin/bash

# "gbu help" command executable.
#
# Can be executed directly.
# Shows the help document.

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
    local brief_usage="gbu help"
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects 0 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nHelp: gbu help"
    local many_args_fmt="\"$brief_usage\" gets too many arguments\nExpects 0 arguments; Gets %s arguments\n"

    if [[ $# -lt 0 ]]; then
        printf "$few_args_fmt" "$#" >|/dev/stderr
        echo -e "$usage" >|/dev/stderr
        exit 1
    elif [[ $# -eq 0 ]]; then
        local help=$(cat \
<<__eof
Usage: gbu <command> ...
==== Commands ====
help:
    When:   You need help info. For example, now.
    How-to: gbu help
info:
    When:   You need too see the package info.
    How-to: gbu info
list-main-names:
    When:   You need to list the main branch name settings
    How-to: gbu list-main-names
clear-main-names:
    When:   You need to restore the default main branch name settings.
    How-to: gbu clear-main-names
set-main-name:
    When:   You need to update the main branch name settings.
    How-to: gbu set-main-name <new-main-name>
list-user-info:
    When:   You need to list the git user info.
    How-to: gbu list-user-info
set-user-info:
    When:   You need to update the git user info.
    How-to: gbu set-user-info <name> <email>
show-graph:
    When:   You need to show the git branch graph.
    How-to: gbu show-graph
create-rel:
    When:   You need to create a rel (release) branch.
    How-to: gbu create-rel
create-dev:
    When:   You need to create a dev (development) branch.
    How-to: gbu create-dev
init-repo:
    When:   You need to initialize the current repository.
    How-to: gbu init-repo
dev-merge-rel:
    When:   You need the dev branch to merge the rel branch.
    How-to: gbu dev-merge-rel
update-feature:
    When:   You need to update a feature with a feature branch.
    How-to: gbu update-feature <feature-branch-name> <feature-commit-message>
rel-merge-dev:
    When:   You need the rel branch to merge the dev branch.
    How-to: gbu rel-merge-dev
update-patch:
    When:   You need to update a patch with a patch branch.
    How-to: gbu update-patch <patch-branch-name> <patch-commit-message>
main-merge-rel:
    When:   You need the main branch to merge the rel branch.
    How-to: gbu main-merge-rel
merge-dev-updates:
    When:   You need rel to merge dev, and then main to merge rel.
    How-to: gbu merge-dev-updates
merge-rel-updates:
    When:   You need dev to merge rel, and then main to merge rel.
    How-to: gbu merge-rel-updates
tag-main:
    When:   You need to tag the latest commit on the main branch.
    How-to: gbu tag-main <tag-name>
push-updates:
    When:   You need to push the local updates to a remote repository.
    How-to: gbu push-updates [<optional-remote>]
pull-updates:
    When:   You need to pull the updates from a remote repository.
    How-to: gbu pull-updates [<optional-remote>]
__eof
        )

        echo -e "$help" | less --quit-if-one-screen --no-init
        exit 0
    else
        printf "$many_args_fmt" "$#" >|/dev/stderr
        echo -e "$usage" >|/dev/stderr
        exit 1
    fi
}

__main "$@"
