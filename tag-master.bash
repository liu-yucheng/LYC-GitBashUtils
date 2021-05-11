#! /bin/bash

# Go to the master branch;
# Tag the latest commit of the master branch as specified ($1);
# Go back to the development (dev) branch.

if [[ $# -ne 1 ]]; then
    echo "Usage: ${0##*/} {tag name}"
    exit 1
fi

(
    # Turn command tracing on
    set -o xtrace

    git checkout master
    git tag $1
    git checkout dev
    git branch
)
