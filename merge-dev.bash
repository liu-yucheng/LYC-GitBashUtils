#! /bin/bash

# Go to the master branch;
# Merge the development (dev) branch;
# Go back to the development branch

if [[ $# -ne 0 ]]; then
    echo "Usage: ${0##*/}"
    exit 1
fi

(
    # Turn command tracing on
    set -o xtrace

    git checkout master
    git merge dev --no-ff -m "Merged development (dev) branch"
    git checkout dev
    git branch
)
