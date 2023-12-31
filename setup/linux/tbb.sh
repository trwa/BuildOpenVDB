#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR="$SCRIPT_DIR"/../..

ONETBB_SRC_DIR="$ROOT_DIR"/oneTBB
ONETBB_BUILD_DIR="$ROOT_DIR"/build/oneTBB
ONETBB_INSTALL_DIR="$ROOT_DIR"/libs

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

cmake --build "$ONETBB_BUILD_DIR"
cmake --install "$ONETBB_BUILD_DIR"
