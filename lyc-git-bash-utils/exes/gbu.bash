#! /bin/bash

# "gbu" command executable.
#
# Can be executed directly.
# Interprets and runs the specified subcommand ($1).

# Copyright 2022 Yucheng Liu. GNU GPL3 license.
# GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname $__file)

# include lyc-git-bash-utils.libs.utils
if [[ -z $_gbu_incl_libs_utils ]]; then
    source $__dir/../libs/utils.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

if [[ -z $_gbu_incl_exes ]]; then
    source $__dir/__init__.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

if [[ -z $_gbu_incl_package_info ]]; then
    source $__dir/../../package-info.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

__main() {
    local brief_usage="gbu <command> ..."
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects >= 0 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nHelp: gbu help"
    local info_fmt="LYC-GitBashUtils (%s) %s\n"

    if [[ $# -lt 0 ]]; then
        printf "$few_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    elif [[ $# -eq 0 ]]; then
        printf "$info_fmt" "$_gbu_name" "$_gbu_ver"
        echo -e "$usage"
        exit 0
    else
        local arg_list=("${@}")
        # declare -p arg_list # Debug
        local subcmd_arg_list=("${arg_list[@]:1}")
        # declare -p subcmd_args # Debug

        case $1 in
        clear-main-names)
            # echo "subcommand clear-main-names" # Debug
            $__dir/gbu-clear-main-names.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        create-dev)
            # echo "subcommand create-dev" # Debug
            $__dir/gbu-create-dev.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        create-rel)
            # echo "subcommand create-rel" # Debug
            $__dir/gbu-create-rel.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        dev-merge-rel)
            # echo "subcommand dev-merge-rel" # Debug
            $__dir/gbu-dev-merge-rel.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        help)
            # echo "subcommand help" # Debug
            $__dir/gbu-help.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        info)
            # echo "subcommand info" # Debug
            $__dir/gbu-info.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        init-repo)
            # echo "subcommand init-repo" # Debug
            $__dir/gbu-init-repo.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        list-main-names)
            # echo "subcommand list-main-names" # Debug
            $__dir/gbu-list-main-names.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        list-user-info)
            # echo "subcommand list-user-info" # Debug
            $__dir/gbu-list-user-info.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        main-merge-rel)
            # echo "subcommand main-merge-rel" # Debug
            $__dir/gbu-main-merge-rel.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        merge-dev-updates)
            # echo "subcommand merge-dev-updates" # Debug
            $__dir/gbu-merge-dev-updates.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        merge-rel-updates)
            # echo "subcommand merge-rel-updates" # Debug
            $__dir/gbu-merge-rel-updates.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        pull-updates)
            # echo "subcommand pull-updates" # Debug
            $__dir/gbu-pull-updates.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        push-updates)
            # echo "subcommand push-updates" # Debug
            $__dir/gbu-push-updates.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        rel-merge-dev)
            # echo "subcommand rel-merge-dev" # Debug
            $__dir/gbu-rel-merge-dev.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        set-main-name)
            # echo "subcommand set-main-name" # Debug
            $__dir/gbu-set-main-name.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        set-user-info)
            # echo "subcommand set-user-info" # Debug
            $__dir/gbu-set-user-info.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        show-graph)
            # echo "subcommand show-graph" # Debug
            $__dir/gbu-show-graph.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        tag-main)
            # echo "subcommand tag-main" # Debug
            $__dir/gbu-tag-main.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        update-feature | update-dev-feature)
            # echo "subcommand update-feature" # Debug
            $__dir/gbu-update-feature.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        update-patch | update-rel-patch)
            # echo "subcommand update-patch" # Debug
            $__dir/gbu-update-patch.bash "${subcmd_arg_list[@]}"
            exit $?
            ;;
        *)
            local unknown_arg_fmt="\"$brief_usage\" gets an unknown argument: %s\n"
            local unknown_cmd_fmt="\"$brief_usage\" gets an unknown command: %s\n"

            if [[ ${1:0:1} == "-" ]]; then
                printf "$unknown_arg_fmt" "$1" >>/dev/stderr
                echo -e "$usage" >>/dev/stderr
                exit 1
            else
                printf "$unknown_cmd_fmt" "$1" >>/dev/stderr
                echo -e "$usage" >>/dev/stderr
                exit 1
            fi
            ;;
        esac
    fi
}

__main "$@"
