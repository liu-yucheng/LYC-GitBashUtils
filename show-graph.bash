#! /bin/bash

# Copyright 2022 Yucheng Liu. GNU GPL3 license.
# GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt

# Show git branch graph (command line simplified version).

if [[ $# -ne 0 ]]; then
    echo "Usage: ${0##*/}"
    exit 1
fi

(
    # Turn command tracing on
    set -o xtrace

    git log --all --decorate --oneline --graph
)
