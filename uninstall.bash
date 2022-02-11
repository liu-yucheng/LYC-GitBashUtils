#! /bin/bash

# Uninstalls the main package.
#
# Remove lines from ~/.bash_profile.
# Removes the installation line that adds the target to PATH.
# Removes the completion line that enables "gbu" command completion.

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

__uninstall() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local install_pattern="export PATH=\".*\" # Install LYC-GitBashUtils"
    local comp_pattern="source .* # Complete LYC-GitBashUtils \"gbu\" command"

    touch ~/.bash_profile
    local profile=$(cat ~/.bash_profile)
    local new_profile=""
    local has_install=0
    local has_comp=0

    local ifs_backup=$IFS
    IFS=$'\n'

    while [[ 1 ]]; do
        local line
        read line

        if [[ $? -ne 0 ]]; then
            break
        fi

        # Detect and remove the installation line
        if [[ $line =~ $install_pattern ]]; then
            local has_install=1
            # echo matched # Debug
            continue
        fi

        # Detect and remove the completion line
        if [[ $line =~ $comp_pattern ]]; then
            local has_comp=1
            continue
        fi

        new_profile=$new_profile$line"\n"
    done <<<$profile

    IFS=$ifs_backup
    echo -ne "$new_profile" >|~/.bash_profile

    if [[ $has_install -eq 0 ]]; then
        echo "Ensured removal of installation line in ~/.bash_profile"
    else
        echo "Removed installation line from ~/.bash_profile"
    fi

    if [[ $has_comp -eq 0 ]]; then
        echo "Ensured removal of completion line in ~/.bash_profile"
    else
        echo "Removed completion line from ~/.bash_profile"
    fi

    echo "Left the app data untouched at: $_gbu_app_data_path"
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
