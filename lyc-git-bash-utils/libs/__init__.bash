#! /bin/bash

# Libraries.

# Copyright 2022 Yucheng Liu. GNU GPL3 license.
# GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt

# Inclusion flag.
_gbu_incl_libs=1

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname ${__file})

if [[ -z $_gbu_incl_root ]]; then
    source $__dir/../__init__.bash
fi

__file=$(realpath ${BASH_SOURCE[0]})
__dir=$(dirname ${__file})
