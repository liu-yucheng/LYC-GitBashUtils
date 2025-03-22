#! /bin/bash

# Utilities.

# Copyright 2022-2025 Yucheng Liu. Under the GNU AGPL 3.0 license.
# GNU AGPL 3.0 license: https://www.gnu.org/licenses/agpl-3.0.txt .

# Inclusion flag.
_gbu_incl_libs_utils=1

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname $__file)

if [[ -z $_gbu_incl_libs ]]; then
    source $__dir/__init__.bash
fi

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname $__file)

# Meta-information ensuring eval line
_gbu_ensure_metainfo_eval="\
\
__file=\$(realpath \${BASH_SOURCE[0]});\
__dir=\$(dirname \$__file)\
\
"
