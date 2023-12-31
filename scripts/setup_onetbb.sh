#!/usr/bin/env bash

ONETBB_SRC_DIR="$PWD"/vendor/oneTBB
ONETBB_BUILD_DIR="$PWD"/build/oneTBB
ONETBB_INSTALL_DIR="$PWD"/libs

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

cmake --build "$ONETBB_BUILD_DIR" --config Release
cmake --install "$ONETBB_BUILD_DIR"
