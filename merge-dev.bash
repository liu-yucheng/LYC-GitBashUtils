#! /bin/bash

# Go to the master branch;
# Merge the development (dev) branch;
# Go back to the development branch

if [[ $# -ne 0 ]]; then
    echo "Usage: ${0##*/}"
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
    git merge dev --no-ff -m "Merged development (dev) branch"
    git checkout dev
    git branch
)
