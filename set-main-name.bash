#! /bin/bash

# Copyright 2022 Yucheng Liu. GNU GPL3 license.
# GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt

# Change the main branch name (in main-names.txt)
# Add the specified name ($1) to the record (in main-names.txt)
# Ensure that the record has no duplicate elements
# Make the name the first place and use it as the new main name

if [[ $# -ne 1 ]]; then
    echo "Usage: ${0##*/} <new main name>"
    exit 1
fi

main_names_loc="${0%/*}/main-names.txt"

main_names=()
while IFS= read -r line || [[ -n "${line}" ]]; do
    line=$(echo "${line}" | tr -d "\n\r")
    if [[ "${line:0:1}" != "#" ]]; then
        main_names+=("${line}")
    fi
done < ${main_names_loc}

printf "Old main name: %s\n" "${main_names[0]}"

name_used=0
name_index=0
for index in ${!main_names[@]}; do
    if [[ "${main_names[index]}" == "$1" ]]; then
        name_used=1
        name_index=${index}
    fi
done

if [[ ${name_used} -ne 0 ]]; then
    main_names=(
        "${main_names[name_index]}"
        "${main_names[@]::name_index}"
        "${main_names[@]:name_index + 1}"
    )
else
    main_names=(
        "$1"
        "${main_names[@]}"
    )
fi

printf "New main name: %s\n" "${main_names[0]}"

printf "%s\n" "${main_names[@]}" > ${main_names_loc}

(
    # Turn command tracing on
    set -o xtrace

    cat "${main_names_loc}"
    git branch
)
