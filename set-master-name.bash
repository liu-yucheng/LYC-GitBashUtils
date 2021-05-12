#! /bin/bash

# Change the registered master name (in master-names.txt);
# Add the specified name ($1) to the record (in master-names.txt);
# Ensure that the record has no duplicate elements;
# Make the name the first place and use it as the new master name.

if [[ $# -ne 1 ]]; then
    echo "Usage: ${0##*/} {new master name}"
    exit 1
fi

master_names_fname="${0%/*}/master-names.txt"

master_names=()
while IFS= read -r line || [[ -n "${line}" ]]; do
    line=$(echo "${line}" | tr -d "\n\r")
    if [[ "${line:0:1}" != "#" ]]; then
        master_names+=("${line}")
    fi
done < ${master_names_fname}

printf "Old master: %s\n" "${master_names[0]}"

name_used=0
name_index=0
for index in ${!master_names[@]}; do
    if [[ "${master_names[index]}" == "$1" ]]; then
        name_used=1
        name_index=${index}
    fi
done

if [[ ${name_used} -ne 0 ]]; then
    master_names=(
        "${master_names[name_index]}"
        "${master_names[@]::name_index}"
        "${master_names[@]:name_index + 1}"
    )
else
    master_names=(
        "$1"
        "${master_names[@]}"
    )
fi

printf "New master: %s\n" "${master_names[0]}"

starting_comment="# Use the first non-comment line as the current master name"
master_names=(
    "${starting_comment}"
    "${master_names[@]}"
)
printf "%s\n" "${master_names[@]}" > ${master_names_fname}

(
    # Turn command tracing on
    set -o xtrace

    cat "${master_names_fname}"
    git branch
)
