#! /bin/bash

# Go to the master branch;
# Tag the latest commit of the master branch as specified ($1);
# Go back to the development (dev) branch.

if [[ $# -ne 1 ]]; then
    echo "Usage: ${0##*/} {tag name}"
    exit 1
fi

master_names=()
while IFS= read -r line || [ -n "${line}" ]; do
    line=$(echo ${line} | tr -d '\n\r')
    if [ "${line:0:1}" != "#" ]; then
        master_names+=("${line}")
    fi
done < "${0%/*}/master-names.txt"

master=master
if [ -n "${master_names[0]}" ]; then
    master=${master_names[0]}
fi

(
    # Turn command tracing on
    set -o xtrace

    git checkout ${master}
    git tag $1
    git checkout dev
    git branch
)
