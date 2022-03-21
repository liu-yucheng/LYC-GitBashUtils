#! /bin/bash

# Uninstalls the main package.
#
# Removes lines from ~/.bash_profile.
# Removes the inclusion line that adds the target to PATH.
# Removes the completion line that enables "gbu" command completion.
#
# Removes lines from ~/.bash_rc.
# Removes the line to source ~/.bash_profile.
#
# Restores the backed-up package permission.

# Copyright 2022 Yucheng Liu. GNU GPL3 license.
# GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname $__file)

# include lyc-git-bash-utils.libs.utils
if [[ -z $_gbu_incl_libs_utils ]]; then
    source $__dir/lyc-git-bash-utils/libs/utils.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

if [[ -z $_gbu_incl_package_info ]]; then
    source $__dir/package-info.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

if [[ -z $_gbu_incl_libs_defaults ]]; then
    source $__dir/lyc-git-bash-utils/libs/defaults.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

__cleanup_profile() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local sec_start_pat="# - LYC-GitBashUtils ~/\.bash_profile installation section"
    local sec_end_pat="# - End of LYC-GitBashUtils ~/\.bash_profile installation section"

    touch ~/.bash_profile
    local profile=$(cat ~/.bash_profile)
    local new_profile=""
    local has_sec=0
    local in_sec=0

    local ifs_backup=$IFS
    IFS=$'\n'

    while [[ 1 ]]; do
        local line
        read -r line

        if [[ $? -ne 0 ]]; then
            break
        fi

        if [[ $line =~ $sec_start_pat ]]; then
            local has_sec=1
            local in_sec=1
        fi

        if [[ $line =~ $sec_end_pat ]]; then
            local in_sec=0
            continue
        fi

        if [[ $in_sec -ne 0 ]]; then
            continue
        fi

        local new_profile="$new_profile$line\n"
    done <<<$profile

    IFS=$ifs_backup

    echo -ne "$new_profile" >|~/.bash_profile

    if [[ $has_sec -eq 0 ]]; then
        echo "Ensured removal of installation section in ~/.bash_profile"
    else
        echo "Removed installation section from ~/.bash_profile"
    fi
}

__cleanup_rc() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local sec_start_pat="# - LYC-GitBashUtils ~/\.bashrc installation section"
    local sec_end_pat="# - End of LYC-GitBashUtils ~/\.bashrc installation section"

    touch ~/.bashrc
    local rc=$(cat ~/.bashrc)
    local new_rc=""
    local has_sec=0
    local in_sec=0

    local ifs_backup=$IFS
    IFS=$'\n'

    while [[ 1 ]]; do
        local line
        read -r line

        if [[ $? -ne 0 ]]; then
            break
        fi

        if [[ $line =~ $sec_start_pat ]]; then
            local has_sec=1
            local in_sec=1
        fi

        if [[ $line =~ $sec_end_pat ]]; then
            local in_sec=0
            continue
        fi

        if [[ $in_sec -ne 0 ]]; then
            continue
        fi

        local new_rc="$new_rc$line\n"
    done <<<$rc

    IFS=$ifs_backup

    echo -ne "$new_rc" >|~/.bashrc

    if [[ $has_sec -eq 0 ]]; then
        echo "Ensured removal of installation section in ~/.bashrc"
    else
        echo "Removed installation section from ~/.bashrc"
    fi
}

__leave_app_data() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    echo "Left the app data untouched at: $_gbu_app_data_path"
}

__restore_pkg_perm() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local pkg_perm=$(cat $_gbu_pkg_perms_loc)

    (
        set -o xtrace # Turn command tracing on

        chmod --recursive $pkg_perm $_gbu_pkg_path
    )

    # echo "Restored package permission"
}

__uninstall() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    __cleanup_profile
    __cleanup_rc
    __leave_app_data
    __restore_pkg_perm
}

__main() {
    local brief_usage=uninstall.bash
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects 0 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nHelp: LYC-GitBashUtils/README.md"
    local info_fmt="Uninstalled %s %s\nCommands no longer available since next Bash login: gbu\n"
    local many_args_fmt="\"$brief_usage\" gets too many arguments\nExpects 0 arguments; Gets %s arguments\n"

    if [[ $# -lt 0 ]]; then
        printf "$few_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    elif [[ $# -eq 0 ]]; then
        __uninstall
        printf "$info_fmt" "$_gbu_name" "$_gbu_ver"
        exit 0
    else
        printf "$many_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    fi
}

__main "$@"
