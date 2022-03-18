#! /bin/bash

# Blackboxes.
#
# Blackbox test functions.

# Copyright 2022 Yucheng Liu. GNU GPL3 license.
# GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt

# Inclusion flag.
_gbu_incl_tests_blackboxes=1

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname $__file)

if [[ -z $_gbu_incl_libs_utils ]]; then
    source $__dir/../../libs/utils.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

if [[ -z $_gbu_incl_tests_libs ]]; then
    source $__dir/__init__.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

__repo_path=$(realpath $__dir/../../../)
# echo $__repo_path # Debug

# Default test data path.
__dft_test_data_path=$__repo_path/lyc-git-bash-utils-default-configs/test-data
# Default test repo path.
__dft_test_repo_path=$__dft_test_data_path/test-repo

__test_data_path=$__repo_path/.lyc-git-bash-utils-test-data
__test_repo_path=$__test_data_path/test-repo
__test_stdin_loc=$__test_data_path/test-stdin.txt
__test_stdout_loc=$__test_data_path/test-stdout.txt
__test_stderr_loc=$__test_data_path/test-stderr.txt

# Test names.
_gbu_tests_blackboxes_test_names=(
    "_gbu_tests_blackboxes_test_gbu"
)

# Sets up the test environment.
_gbu_tests_blackboxes_setup() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    mkdir $__test_data_path 1>>/dev/null 2>>/dev/null

    rm -r $__test_repo_path 1>>/dev/null 2>>/dev/null
    cp -r $__dft_test_repo_path $__test_repo_path 1>>/dev/null 2>>/dev/null

    touch $__test_stdin_loc 1>>/dev/null 2>>/dev/null
    touch $__test_stdout_loc 1>>/dev/null 2>>/dev/null
    touch $__test_stderr_loc 1>>/dev/null 2>>/dev/null
}

# Tears down the test environment.
_gbu_tests_blackboxes_tear_down() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    rm -r $__test_repo_path 1>>/dev/null 2>>/dev/null
}

# Tests the gbu command.
_gbu_tests_blackboxes_test_gbu() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local test_name="_gbu_tests_blackboxes_test_gbu"
    local header="- $test_name\n\n"
    echo -ne "$header" >>$__test_stdin_loc
    echo -ne "$header" >>$__test_stdout_loc
    echo -ne "$header" >>$__test_stderr_loc

    local pwd_backup=$(pwd)
    cd $__test_repo_path 1>>/dev/null 2>>/dev/null

    local cmd="gbu"
    echo "$cmd" >>$__test_stdin_loc
    $cmd 1>>$__test_stdout_loc 2>>$__test_stderr_loc
    local cmd_exit_code=$?

    cd $pwd_backup 1>>/dev/null 2>>/dev/null

    local trailer="\n- End of $test_name\n"
    echo -ne "$trailer" >>$__test_stdin_loc
    echo -ne "$trailer" >>$__test_stdout_loc
    echo -ne "$trailer" >>$__test_stderr_loc

    if [[ $cmd_exit_code -ne 0 ]]; then
        local fail_msg="\
\
$test_name: failed\n\
  running command \"$cmd\" results in exit code: $cmd_exit_code\n\
  however, the expected exit code is: 0\n\
\
        "
        echo -ne "$fail_msg" >>/dev/stderr
    fi
}
