#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ONETBB_SRC_DIR="$SCRIPT_DIR"/../oneTBB
ONETBB_BUILD_DIR="$SCRIPT_DIR"/../build/oneTBB
ONETBB_INSTALL_DIR="$SCRIPT_DIR"/../libs

rm -rf "$ONETBB_BUILD_DIR"
mkdir -p "$ONETBB_BUILD_DIR"

# docs:
# https://github.com/oneapi-src/oneTBB/blob/master/cmake/README.md

cmake                                          \
  -DCMAKE_INSTALL_PREFIX="$ONETBB_INSTALL_DIR" \
  -DTBB_TEST=OFF                               \
  -DTBB_DISABLE_HWLOC_AUTOMATIC_SEARCH=TRUE    \
  -B "$ONETBB_BUILD_DIR"                       \
  -S "$ONETBB_SRC_DIR"                         \
  --fresh

cmake --build "$ONETBB_BUILD_DIR" # --config Release
cmake --install "$ONETBB_BUILD_DIR"
