#! /bin/bash

# Go to the main branch
# Merge the development (dev) branch
# Go back to the development branch

if [[ $# -ne 0 ]]; then
    echo "Usage: ${0##*/}"
    exit 1
fi

main_names=()
while IFS= read -r line || [[ -n "${line}" ]]; do
    line=$(echo "${line}" | tr -d "\n\r")
    if [[ "${line:0:1}" != "#" ]]; then
        main_names+=("${line}")
    fi
done < "${0%/*}/main-names.txt"

main="main"
if [[ -n "${main_names[0]}" ]]; then
    main=${main_names[0]}
fi

(
    # Turn command tracing on
    set -o xtrace

    git checkout ${main}
    git merge dev --no-ff -m "Merged development (dev) branch"
    git checkout dev
    git branch
)
