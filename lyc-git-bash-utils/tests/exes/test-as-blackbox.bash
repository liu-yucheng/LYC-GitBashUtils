#! /bin/bash

# Tests the app as a blackbox.
#
# Can be run as an executable.

# Copyright 2022-2025 Yucheng Liu. Under the GNU AGPL 3.0 license.
# GNU AGPL 3.0 license: https://www.gnu.org/licenses/agpl-3.0.txt .

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname $__file)

if [[ -z $_gbu_incl_libs_utils ]]; then
    source $__dir/../../libs/utils.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

if [[ -z $_gbu_incl_tests_exes ]]; then
    source $__dir/__init__.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

if [[ -z $_gbu_incl_tests_libs_blackboxes ]]; then
    source $__dir/../libs/blackboxes.bash
    eval "$_gbu_ensure_metainfo_eval"
fi

__repo_path=$(realpath $__dir/../../..)
__test_data_path=$__repo_path/.lyc-git-bash-utils-test-data
__failed_stderr_loc=$__test_data_path/-failed-stderr.txt

__run_tests() {
    if [[ $# -ne 0 ]]; then
        return 1
    fi

    local test_cnt=0
    local succ_cnt=0
    local fail_cnt=0

    local test_idx=0
    local test_ttl="${#_gbu_blackbox_tests[@]}"

    mkdir $__test_data_path 1>>/dev/null 2>>/dev/null
    touch $__failed_stderr_loc

    local start_time=$SECONDS
    
    _gbu_setup_blackbox_tests

    for test_fn in "${_gbu_blackbox_tests[@]}"; do
        $test_fn 1>>/dev/null 2>>$__failed_stderr_loc
        local exit_code=$?
        local test_cnt=$(($test_cnt + 1))

        if [[ $exit_code -eq 0 ]]; then
            echo -ne "."
            local succ_cnt=$(($succ_cnt + 1))
        else
            echo -ne "F"
            local fail_cnt=$(($fail_cnt + 1))
        fi

        if [[ 
            $((($test_idx + 1) % 60)) -eq 0 ||
            $(($test_idx + 1)) -eq $test_ttl ]]; then
            echo -ne "\n"
        fi

        local test_idx=$(($test_idx + 1))
    done

    _gbu_tear_down_blackbox_tests

    local end_time=$SECONDS
    local taken_time_secs=$(($end_time - $start_time))

    local taken_hrs=$(($taken_time_secs / 3600))

    local taken_mins=$((($taken_time_secs / 60) - $taken_hrs * 60))
    local taken_mins=$(printf "%02d" "$taken_mins")

    local taken_secs=$(($taken_time_secs - $taken_mins * 60 - $taken_hrs * 3600))
    local taken_secs=$(printf "%02d" "$taken_secs")

    local test_summ="\
-
Ran $test_cnt tests  Time taken: $taken_hrs:$taken_mins:$taken_secs (hours: minutes: seconds)
Successes: $succ_cnt  Failures: $fail_cnt
"

    echo -ne "$test_summ"

    if [[ $fail_cnt -gt 0 ]]; then
        local details=$(cat $__failed_stderr_loc)

        local fail_details="\
- Failure details

$details

- End of failure details
"

        echo -ne "$fail_details"
    fi

    rm -f $__failed_stderr_loc
}

__main() {
    local brief_usage=test-as-blackbox.bash
    local few_args_fmt="\"$brief_usage\" gets too few arguments\nExpects 0 arguments; Gets %s arguments\n"
    local usage="Usage: $brief_usage\nHelp: LYC-GitBashUtils/README.md"
    local many_args_fmt="\"$brief_usage\" gets too many arguments\nExpects 0 arguments; Gets %s arguments\n"

    if [[ $# -lt 0 ]]; then
        printf "$few_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    elif [[ $# -eq 0 ]]; then
        __run_tests
        exit 0
    else
        printf "$many_args_fmt" "$#" >>/dev/stderr
        echo -e "$usage" >>/dev/stderr
        exit 1
    fi
}

__main "$@"
