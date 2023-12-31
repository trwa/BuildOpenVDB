#!/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ZLIB_SRC_DIR="$SCRIPT_DIR"/../zlib
ZLIB_BUILD_DIR="$SCRIPT_DIR"/../build/zlib
ZLIB_INSTALL_DIR="$SCRIPT_DIR"/../libs

rm -rf "$ZLIB_BUILD_DIR"
mkdir -p "$ZLIB_BUILD_DIR"

cmake                                        \
  -DCMAKE_INSTALL_PREFIX="$ZLIB_INSTALL_DIR" \
  -DBUILD_SHARED_LIBS=TRUE                   \
  -B "$ZLIB_BUILD_DIR"                       \
  -S "$ZLIB_SRC_DIR"                         \
  --fresh

cmake --build "$ZLIB_BUILD_DIR" --config Release
cmake --install "$ZLIB_BUILD_DIR"
