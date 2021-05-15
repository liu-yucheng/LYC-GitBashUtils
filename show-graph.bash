#! /bin/bash

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
