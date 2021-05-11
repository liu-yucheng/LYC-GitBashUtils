#! /bin/bash

# Go to the master branch;
# Tag the latest commit of the master branch as specified ($1);
# Go back to the development (dev) branch.

if [[ $# -ne 1 ]]; then
    echo "Usage: ${0##*/} {tag name}"
    exit 1
fi

master_branch=master

master_branch_names=()
while IFS= read -r line || [ -n "${line}" ]; do
    line=$(echo ${line} | tr -d '\n\r')
    master_branch_names+=("${line}")
done < "${0%/*}/master-branch-names.txt"

if [ -n "${master_branch_names[0]}" ]; then
    master_branch=${master_branch_names[0]}
fi

(
    # Turn command tracing on
    set -o xtrace

    git checkout ${master_branch}
    git tag $1
    git checkout dev
    git branch
)
