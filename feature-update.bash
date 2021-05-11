#! /bin/bash

# Create the specified feature (f_*) branch ($1);
# Go to the created feature branch;
# Add and commit all changes;
# Log the specified commit message ($2);
# Go back to the development (dev) branch;
# Delete the created feature branch.

if [[ $# -ne 2 ]]; then
    printf '%s' "Usage: ${0##*/} {feature branch name} " \
        "{feature commit message}"
    printf '\n'
    exit 1
fi

(
    # Turn command tracing on
    set -o xtrace

    git branch $1
    git checkout $1
    git add -A
    git status
    git commit -m "$2"
    git checkout dev
    git merge $1 --no-ff -m "Merged feature branch $1"
    git branch -d $1
    git branch
)
