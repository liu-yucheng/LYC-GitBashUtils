#! /bin/bash

# Installs the main package.
#
# Adds lines to ~/.bash_profile.
# Adds an inclusion line that appends the target to PATH.
# Adds a completion line that enables "gbu" command completion.
#
# Adds lines to ~/.bashrc.
# Adds a line to source ~/.bash_profile.
#
# Ensures the app data directory.
# Backs-up the package permissions to the app data directory.
# Sets the package permissions to 755.

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

__ensure_profile() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local incl_path=$__dir/lyc-git-bash-utils/path-includes
    local incl="export PATH=\"\$PATH:$incl_path\" # Install LYC-GitBashUtils"
    local incl_pattern="export PATH=\".*\" # Install LYC-GitBashUtils"

    local comp_loc=$__dir/lyc-git-bash-utils/libs/comp.bash
    local comp="source \"$comp_loc\" # Complete LYC-GitBashUtils \"gbu\" command"
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

        # Detect and ensure the inclusion line
        if [[ $line =~ $incl_pattern ]]; then
            local has_incl=1
            local line=$incl
            # echo matched # Debug
        fi

        # Detect and ensure the completion line
        if [[ $line =~ $comp_pattern ]]; then
            local has_comp=1
            local line=$comp
        fi

        local new_profile="$new_profile$line\n"
    done <<<$profile

    IFS=$ifs_backup

    # Add the inclusion line if it does not exist
    if [[ $has_incl -eq 0 ]]; then
        local new_profile="$new_profile$incl\n"
    fi

    # Add the completion line if it does not exist
    if [[ $has_comp -eq 0 ]]; then
        local new_profile="$new_profile$comp\n"
    fi

    echo -ne "$new_profile" >|~/.bash_profile

    if [[ $has_incl -eq 0 ]]; then
        echo "Added inclusion line to ~/.bash_profile"
    else
        echo "Ensured inclusion line in ~/.bash_profile"
    fi

    if [[ $has_comp -eq 0 ]]; then
        echo "Added completion line to ~/.bash_profile"
    else
        echo "Ensured completion line in ~/.bash_profile"
    fi
}

__ensure_rc() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local source="source ~/.bash_profile # Install LYC-GitBashUtils"
    local source_pattern="source ~/\.bash_profile # Install LYC-GitBashUtils"

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

        # Detect and ensure the source line
        if [[ $line =~ $source_pattern ]]; then
            local has_source=1
            local line=$source
        fi

        local new_rc="$new_rc$line\n"
    done <<<$rc

    IFS=$ifs_backup

    # Adds the source line if it does not exist
    if [[ $has_source -eq 0 ]]; then
        local new_rc="$new_rc$source\n"
    fi

    echo -ne "$new_rc" >|~/.bashrc

    if [[ $has_source -eq 0 ]]; then
        echo "Added source line to ~/.bashrc"
    else
        echo "Ensured source line in ~/.bashrc"
    fi
}

__ensure_app_data() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    if [[ -e $_gbu_app_data_path ]]; then
        echo "Ensured the app data at: $_gbu_app_data_path"
    else
        cp -r $_gbu_dft_app_data_path $_gbu_app_data_path
        echo "Created the app data at: $_gbu_app_data_path"
    fi
}

__ensure_pkg_perms() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local pkg_perm=$(stat -c "%a" $_gbu_pkg_path)
    echo -ne "$pkg_perm" >|$_gbu_pkg_perms_loc

    (
        set -o xtrace # Turn command tracing on

        chmod --recursive 755 $_gbu_pkg_path
    )

    # echo "Ensured package permissions"
}

__install() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    __ensure_profile
    __ensure_rc
    __ensure_app_data
    __ensure_pkg_perms
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
