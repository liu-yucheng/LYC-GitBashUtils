#! /bin/bash

# Installs the main package.
#
# Adds line to ~/.bash_profile.
# Adds an installation line that appends the target to PATH.
# Adds a completion line that enables "gbu" command completion.

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

__install() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local incl_path=$__dir/lyc-git-bash-utils/path-includes
    local install="export PATH=\"\$PATH:$incl_path\" # Install LYC-GitBashUtils"
    local install_pattern="export PATH=\".*\" # Install LYC-GitBashUtils"

    local comp_loc=$__dir/lyc-git-bash-utils/libs/comp.bash
    local comp="source \"$comp_loc\" # Complete LYC-GitBashUtils \"gbu\" command"
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

        # Detect and ensure the installation line
        if [[ $line =~ $install_pattern ]]; then
            local has_install=1
            local line=$install
            # echo matched # Debug
        fi

        # Detect and ensure the completion line
        if [[ $line =~ $comp_pattern ]]; then
            local has_comp=1
            local line=$comp
        fi

        new_profile=$new_profile$line"\n"
    done <<<$profile

    IFS=$ifs_backup

    # Add the installation line if it does not exist
    if [[ $has_install -eq 0 ]]; then
        new_profile=$new_profile$install"\n"
    fi

    # Add the completion line if it does not exist
    if [[ $has_comp -eq 0 ]]; then
        new_profile=$new_profile$comp"\n"
    fi

    echo -ne "$new_profile" >|~/.bash_profile

    if [[ $has_install -eq 0 ]]; then
        echo "Added installation line to ~/.bash_profile"
    else
        echo "Ensured installation line in ~/.bash_profile"
    fi

    if [[ $has_comp -eq 0 ]]; then
        echo "Added completion line to ~/.bash_profile"
    else
        echo "Ensured completion line in ~/.bash_profile"
    fi

    if [[ -e $_gbu_app_data_path ]]; then
        echo "Ensured the app data path at: $_gbu_app_data_path"
    else
        cp -r $_gbu_dft_app_data_path $_gbu_app_data_path
        echo "Created the app data path at: $_gbu_app_data_path"
    fi
}

__main() {
    local brief_usage=install.bash
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects 0 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nHelp: LYC-GitBashUtils/README.md"
    local info_fmt="Installed %s %s\nCommands available upon next Bash login: gbu\n"
    local many_args_fmt="\"$brief_usage\" gets too many arguments\nExpects 0 arguments; Gets %s arguments\n"

    if [[ $# -lt 0 ]]; then
        printf "$few_args_fmt" "$#" >|/dev/stderr
        echo -e "$usage" >|/dev/stderr
        exit 1
    elif [[ $# -eq 0 ]]; then
        __install
        printf "$info_fmt" "$_gbu_name" "$_gbu_ver"
        exit 0
    else
        printf "$many_args_fmt" "$#" >|/dev/stderr
        echo -e "$usage" >|/dev/stderr
        exit 1
    fi
}

__main "$@"
