#! /bin/bash

# Go to the main branch;
# Tag the latest commit of the main branch as specified ($1);
# Go back to the development (dev) branch.

if [[ $# -ne 1 ]]; then
    echo "Usage: ${0##*/} <tag name>"
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

main="main"
if [ -n "${main_names[0]}" ]; then
    main=${main_names[0]}
fi

(
    # Turn command tracing on
    set -o xtrace

    git checkout ${main}
    git tag $1
    git checkout dev
    git branch
)
