#! /bin/bash

# Tests.

# Copyright 2022-2025 Yucheng Liu. Under the GNU AGPL 3.0 license.
# GNU AGPL 3.0 license: https://www.gnu.org/licenses/agpl-3.0.txt .

# Inclusion flag
_gbu_incl_tests=1

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname $__file)

if [[ -z $_gbu_incl_root ]]; then
    source $__dir/../__init__.bash
    __file=$(realpath ${BASH_SOURCE[0]})
    __dir=$(dirname $__file)
fi
