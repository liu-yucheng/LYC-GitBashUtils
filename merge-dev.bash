#! /bin/bash

# Go to the master branch;
# Merge the development (dev) branch;
# Go back to the development branch

if [[ $# -ne 0 ]]; then
    echo "Usage: ${0##*/}"
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
    git merge dev --no-ff -m "Merged development (dev) branch"
    git checkout dev
    git branch
)
