#! /bin/bash

# Clear all custom master names;
# Retain the default master name (master).

if [[ $# -ne 0 ]]; then
    echo "Usage: ${0##*/}"
    exit 1
fi

master_names_fname="${0%/*}/master-names.txt"

master_names=()
master_names[0]="# Use the first non-comment line as the current master name"
master_names[1]="master"

printf "%s\n" "${master_names[@]}" > "${master_names_fname}"

(
    # Turn command tracing on
    set -o xtrace

    cat "${master_names_fname}"
    git branch
)
