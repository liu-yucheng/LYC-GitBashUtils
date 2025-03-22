#! /bin/bash

# Defaults.

# Copyright 2022-2025 Yucheng Liu. Under the GNU AGPL 3.0 license.
# GNU AGPL 3.0 license: https://www.gnu.org/licenses/agpl-3.0.txt .

# Inclusion flag.
_gbu_incl_libs_defaults=1

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

# Repository path
_gbu_repo_path=$(realpath $__dir/../..)

# Package path
_gbu_pkg_path=$_gbu_repo_path/lyc-git-bash-utils

# Default configs path.
_gbu_dft_cfgs_path=$_gbu_repo_path/lyc-git-bash-utils-default-configs
# Default app data path.
_gbu_dft_app_data_path=$_gbu_dft_cfgs_path/app-data
# Default main names location.
_gbu_dft_main_names_loc=$_gbu_dft_app_data_path/main-branch-names.txt
# Default package permissions location.
_gbu_dft_pkg_perms_loc=$_gbu_dft_app_data_path/package-permissions.txt

# App data path.
_gbu_app_data_path=$_gbu_repo_path/.lyc-git-bash-utils-app-data
# Main names location.
_gbu_main_names_loc=$_gbu_app_data_path/main-branch-names.txt
# Package permission location.
_gbu_pkg_perms_loc=$_gbu_app_data_path/package-permissions.txt
