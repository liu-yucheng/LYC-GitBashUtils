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
__dir=$(dirname ${__file})

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

    local incl_pattern="export PATH=\".*\" # Install LYC-GitBashUtils"
    local comp_pattern="source .* # Complete LYC-GitBashUtils \"gbu\" command"

    touch ~/.bash_profile
    local profile=$(cat ~/.bash_profile)
    local new_profile=""
    local has_incl=0
    local has_comp=0

    local ifs_backup=$IFS
    IFS=$'\n'

    while [[ 1 ]]; do
        local line
        read -r line

        if [[ $? -ne 0 ]]; then
            break
        fi

        # Detect and remove the inclusion line
        if [[ $line =~ $incl_pattern ]]; then
            local has_incl=1
            # echo matched # Debug
            continue
        fi

        # Detect and remove the completion line
        if [[ $line =~ $comp_pattern ]]; then
            local has_comp=1
            continue
        fi

        local new_profile="$new_profile$line\n"
    done <<<$profile

    IFS=$ifs_backup
    echo -ne "$new_profile" >|~/.bash_profile

    if [[ $has_incl -eq 0 ]]; then
        echo "Ensured removal of inclusion line in ~/.bash_profile"
    else
        echo "Removed inclusion line from ~/.bash_profile"
    fi

    if [[ $has_comp -eq 0 ]]; then
        echo "Ensured removal of completion line in ~/.bash_profile"
    else
        echo "Removed completion line from ~/.bash_profile"
    fi
}

__cleanup_rc() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local source_pattern="source ~/\.bashrc # Install LYC-GitBashUtils"

    touch ~/.bashrc
    local rc=$(cat ~/.bashrc)
    local new_rc=""
    local has_source=0

    local ifs_backup=$IFS
    IFS=$'\n'

    while [[ 1 ]]; do
        local line
        read -r line

        if [[ $? -ne 0 ]]; then
            break
        fi

        # Detect and remove the inclusion line
        if [[ $line =~ $source_pattern ]]; then
            local has_source=1
            continue
        fi

        local new_rc="$new_rc$line\n"
    done <<<$rc

    IFS=$ifs_backup
    echo -ne "$new_rc" >|~/.bashrc

    if [[ $has_source -eq 0 ]]; then
        echo "Ensured removal of source line in ~/.bashrc"
    else
        echo "Removed source line from ~/.bashrc"
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
        printf "$few_args_fmt" "$#" >|/dev/stderr
        echo -e "$usage" >|/dev/stderr
        exit 1
    elif [[ $# -eq 0 ]]; then
        __uninstall
        printf "$info_fmt" "$_gbu_name" "$_gbu_ver"
        exit 0
    else
        printf "$many_args_fmt" "$#" >|/dev/stderr
        echo -e "$usage" >|/dev/stderr
        exit 1
    fi
}

__main "$@"
