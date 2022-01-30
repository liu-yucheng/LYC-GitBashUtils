#! /bin/bash

# Copyright 2022 Yucheng Liu. GNU GPL3 license.
# GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt

# Push all branches to the origin or specified ($1) remote.

if [[ $# -ge 2 ]]; then
    echo "Usage: ${0##*/} [(optional) <remote name>]"
    exit 1
fi

remote="origin"
if [[ $# -eq 1 ]]; then
    remote=$1
fi

(
    # Turn command tracing on
    set -o xtrace

    git push ${remote} "*:*"
)
