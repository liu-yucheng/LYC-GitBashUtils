#! /bin/bash

# Create a development (dev) branch;
# Go to the development branch.

if [[ $# -ne 0 ]]; then
    echo "Usage: ${0##*/}"
    exit 1
fi

(
    # Turn command tracing on
    set -o xtrace

    git branch dev
    git checkout dev
    git branch
)
