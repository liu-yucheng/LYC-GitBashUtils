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
__dir=$(dirname $__file)

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

if [[ -z $_gbu_incl_libs_comps ]]; then
    source $__dir/lyc-git-bash-utils/libs/comps.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

__utils_loc=$__dir/lyc-git-bash-utils/libs/utils.bash
__comps_loc=$__dir/lyc-git-bash-utils/libs/comps.bash
__incl_path=$__dir/lyc-git-bash-utils/path-includes

__sec_content=$(
cat << __eof
# Install to the PATH environment variable
export PATH="\$PATH:$__incl_path"

# Complete the "gbu" command
$_gbu_comp_cmd
__eof
)

__ensure_profile() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local sec=$(
cat << __eof
# - LYC-GitBashUtils ~/.bash_profile installation section

$__sec_content

# - End of LYC-GitBashUtils ~/.bash_profile installation section
__eof
    )

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

    local new_profile="$new_profile$sec\n"
    echo -ne "$new_profile" >|~/.bash_profile

    if [[ $has_sec -eq 0 ]]; then
        echo "Added installation section to ~/.bash_profile"
    else
        echo "Ensured installation section in ~/.bash_profile"
    fi
}

__ensure_rc() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local sec=$(
cat << __eof
# - LYC-GitBashUtils ~/.bashrc installation section

$__sec_content

# - End of LYC-GitBashUtils ~/.bashrc installation section
__eof
    )

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

    local new_rc="$new_rc$sec\n"
    echo -ne "$new_rc" >|~/.bashrc

    if [[ $has_sec -eq 0 ]]; then
        echo "Added installation section to ~/.bashrc"
    else
        echo "Ensured installation section in ~/.bashrc"
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
        printf "$few_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    elif [[ $# -eq 0 ]]; then
        __install
        printf "$info_fmt" "$_gbu_name" "$_gbu_ver"
        exit 0
    else
        printf "$many_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    fi
}

__main "$@"
