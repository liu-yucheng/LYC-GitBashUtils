#! /bin/bash

# Blackboxes.
#
# Blackbox test functions.

# Copyright 2022 Yucheng Liu. GNU GPL3 license.
# GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt

# Inclusion flag.
_gbu_incl_tests_libs_blackboxes=1

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

__repo_path=$(realpath $__dir/../../..)
# declare -p __repo_path # Debug

# Default test data path.
__dft_test_data_path=$__repo_path/lyc-git-bash-utils-default-configs/test-data
# Default test repo path.
__dft_test_repo_path=$__dft_test_data_path/test-repo

__test_data_path=$__repo_path/.lyc-git-bash-utils-test-data
__test_repo_path=$__test_data_path/test-repo
__test_stdin_loc=$__test_data_path/test-stdin.txt
__test_stdout_loc=$__test_data_path/test-stdout.txt
__test_stderr_loc=$__test_data_path/test-stderr.txt

__app_data_path=$__repo_path/.lyc-git-bash-utils-app-data

__main_names_loc=$__app_data_path/main-branch-names.txt
__main_names_backup_loc=$__test_data_path/main-branch-names-backup.txt

__user_name_backup_loc=$__test_data_path/user-name-backup.txt
__user_email_backup_loc=$__test_data_path/user-email-backup.txt

# "gbu" blackbox tests
_gbu_blackbox_tests=(
    "_gbu_test_gbu"
    "_gbu_test_gbu_help"
    "_gbu_test_info"

    "_gbu_test_list_main_names"
    "_gbu_test_list_user_info"
    "_gbu_test_clear_main_names"
    "_gbu_test_set_main_name"
    "_gbu_test_set_user_info"

    "_gbu_test_init_repo"
    "_gbu_test_create_dev"
    "_gbu_test_create_rel"

    "_gbu_test_show_graph"
)

# Sets up the blackbox test environment.
_gbu_setup_blackbox_tests() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    mkdir $__test_data_path 1>>/dev/null 2>>/dev/null

    rm -rf $__test_repo_path 1>>/dev/null 2>>/dev/null
    cp -rf $__dft_test_repo_path $__test_repo_path 1>>/dev/null 2>>/dev/null

    touch $__test_stdin_loc 1>>/dev/null 2>>/dev/null
    touch $__test_stdout_loc 1>>/dev/null 2>>/dev/null
    touch $__test_stderr_loc 1>>/dev/null 2>>/dev/null
}

# Tears down the blackbox test environment.
_gbu_tear_down_blackbox_tests() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    rm -rf $__test_repo_path 1>>/dev/null 2>>/dev/null
}

# -

# Tests a simple command.
#
# Args:
#   $#: needs to -eq 2 else return 1
#   $1: test name
#   $2: command to test
__test_simple_cmd() {
    if [[ $# -ne 2 ]]; then
        return 1
    fi

    local test_name=$1
    local header="- $test_name\n\n"
    echo -ne "$header" >>$__test_stdin_loc
    echo -ne "$header" >>$__test_stdout_loc
    echo -ne "$header" >>$__test_stderr_loc

    local pwd_backup=$(pwd)
    cd $__test_repo_path 1>>/dev/null 2>>/dev/null

    local cmd=$2
    echo "$cmd" >>$__test_stdin_loc
    eval "$cmd 1>>$__test_stdout_loc 2>>$__test_stderr_loc"
    local exit_code=$?

    cd $pwd_backup 1>>/dev/null 2>>/dev/null

    local trailer="\n- End of $test_name\n"
    echo -ne "$trailer" >>$__test_stdin_loc
    echo -ne "$trailer" >>$__test_stdout_loc
    echo -ne "$trailer" >>$__test_stderr_loc

    if [[ $exit_code -ne 0 ]]; then
        local fail_msg="\
$test_name: failed
  running command \"$cmd\" results in exit code: $exit_code
  however, the expected exit code is: 0
"

        echo -ne "$fail_msg" >>/dev/stderr
        return 1
    else
        return 0
    fi
}

# Tests the "gbu" command.
_gbu_test_gbu() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    __test_simple_cmd "_gbu_test_gbu" "gbu"
    local exit_code=$?
    return $exit_code
}

# Tests the "gbu help" command.
_gbu_test_gbu_help() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    __test_simple_cmd "_gbu_test_gbu_help" "gbu help"
    local exit_code=$?
    return $exit_code
}

# Tests the "gbu info" command.
_gbu_test_info() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    __test_simple_cmd "_gbu_test_info" "gbu info"
    local exit_code=$?
    return $exit_code
}

# -

# Tests the "gbu list-main-names" command.
_gbu_test_list_main_names() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    __test_simple_cmd "_gbu_test_list_main_names" "gbu list-main-names"
    local exit_code=$?
    return $exit_code
}

# Tests the "gbu list-user-info" command.
_gbu_test_list_user_info() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    __test_simple_cmd "_gbu_test_list_user_info" "gbu list-user-info"
    local exit_code=$?
    return $exit_code
}

# Tests the "gbu clear-main-names" command.
_gbu_test_clear_main_names() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    cat $__main_names_loc >|$__main_names_backup_loc

    __test_simple_cmd "_gbu_test_clear_main_names" "gbu clear-main-names"
    local exit_code=$?

    cat $__main_names_backup_loc >|$__main_names_loc
    rm -f $__main_names_backup_loc 1>>/dev/null 2>>/dev/null

    return $exit_code
}

# Tests the "gbu set-main-name ..." command.
_gbu_test_set_main_name() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    cat $__main_names_loc >|$__main_names_backup_loc

    __test_simple_cmd "_gbu_test_set_main_name" "gbu set-main-name \"test main\""
    local exit_code=$?

    cat $__main_names_backup_loc >|$__main_names_loc
    rm -f $__main_names_backup_loc 1>>/dev/null 2>>/dev/null

    return $exit_code
}

# Tests the "gbu set-user-info ..." command.
_gbu_test_set_user_info() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    git config --global --get-all user.name >|$__user_name_backup_loc
    git config --global --get-all user.email >|$__user_email_backup_loc

    __test_simple_cmd "_gbu_test_set_user_info" "gbu set-user-info \"Gbu Test\" \"gbu.test@email.com\""
    local exit_code=$?

    local user_name=$(cat $__user_name_backup_loc)
    local user_email=$(cat $__user_email_backup_loc)

    git config --global --get-all user.name $user_name
    git config --global --get-all user.email $user_email

    rm -f $__user_name_backup_loc 1>>/dev/null 2>>/dev/null
    rm -f $__user_email_backup_loc 1>>/dev/null 2>>/dev/null

    return $exit_code
}

# -

# Tests the "gbu init-repo" command.
_gbu_test_init_repo() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    __test_simple_cmd "_gbu_test_init_repo" "gbu init-repo"
    local exit_code=$?
    return $exit_code
}

# Tests the "gbu create-dev" command.
_gbu_test_create_dev() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    __test_simple_cmd "_gbu_test_create_dev" "gbu create-dev"
    local exit_code=$?
    return $exit_code
}

# Tests the "gbu create-rel" command.
_gbu_test_create_rel() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    __test_simple_cmd "_gbu_test_create_rel" "gbu create-rel"
    local exit_code=$?
    return $exit_code
}

# -

# Tests a list of commands.
#
# The list of commands is passed in as a string argument.
# Each command in the list will be tested in the listed order.
# If any of the commands exits with a non-zero exit code, the test fails.
# Each command in the list will be executed, no matter if the test fails.
#
# Args:
#   $#: needs to -ge 2 else return 1
#   $1: test name
#   $2: number of elements in the list consists of arguments $3 to ${3 + $2}
#   $3 to ${3 + $2}: list of commands
__test_cmds() {
    if [[ $# -lt 2 ]]; then
        return 1
    fi

    local test_name=$1
    local header="- $test_name\n\n"
    echo -ne "$header" >>$__test_stdin_loc
    echo -ne "$header" >>$__test_stdout_loc
    echo -ne "$header" >>$__test_stderr_loc

    local pwd_backup=$(pwd)
    cd $__test_repo_path 1>>/dev/null 2>>/dev/null

    local cmds_len=$2
    local cmds=("${@:3:$cmds_len}")
    local -a exit_codes

    for idx in ${!cmds[@]}; do
        local cmd="${cmds[idx]}"
        echo "$cmd" >>$__test_stdin_loc
        eval "$cmd 1>>$__test_stdout_loc 2>>$__test_stderr_loc"
        local exit_code=$?
        exit_codes[$idx]=$exit_code
    done

    cd $pwd_backup 1>>/dev/null 2>>/dev/null

    local trailer="\n- End of $test_name\n"
    echo -ne "$trailer" >>$__test_stdin_loc
    echo -ne "$trailer" >>$__test_stdout_loc
    echo -ne "$trailer" >>$__test_stderr_loc

    for idx in ${!cmds[@]}; do
        local exit_code=${exit_codes[idx]}

        if [[ $exit_code -ne 0 ]]; then
            local cmd="${cmds[idx]}"

            local fail_msg="\
$test_name: failed
  running command \"$cmd\" results in exit code: $exit_code
  however, the expected exit code is: 0
"

            echo -ne "$fail_msg" >>/dev/stderr
            return 1
        fi
    done

    return 0
}

# Tests the "gbu show-graph" command.
#
# Depends on "gbu init-repo."
_gbu_test_show_graph() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local cmds=(
        "gbu init-repo"
        "gbu show-graph"
    )

    local cmds_len=${#cmds[@]}
    __test_cmds "_gbu_test_show_graph" $cmds_len "${cmds[@]}"
    local exit_code=$?
    return $exit_code
}
