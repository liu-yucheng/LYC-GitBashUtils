#! /bin/bash

# Clear all custom master names;
# Retain the default master name (master).

if [[ $# -ne 0 ]]; then
    echo "Usage: ${0##*/}"
    exit 1
fi

starting_comment='# Use the first non-comment line as the current master name'
master_names=(
    "${starting_comment}"
    master
)
printf "%s\n" "${master_names[@]}" > "${0%/*}/master-names.txt"

(
    # Turn command tracing on
    set -o xtrace

    cat "${0%/*}/master-names.txt"
    git branch
)
