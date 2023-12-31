#!/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR="$SCRIPT_DIR"/../..

ZLIB_SRC_DIR="$ROOT_DIR"/zlib
ZLIB_BUILD_DIR="$ROOT_DIR"/build/zlib
ZLIB_INSTALL_DIR="$ROOT_DIR"/libs

rm -rf "$ZLIB_BUILD_DIR"
mkdir -p "$ZLIB_BUILD_DIR"

cmake                                        \
  -DCMAKE_INSTALL_PREFIX="$ZLIB_INSTALL_DIR" \
  -DBUILD_SHARED_LIBS=TRUE                   \
  -B "$ZLIB_BUILD_DIR"                       \
  -S "$ZLIB_SRC_DIR"                         \
  --fresh

cmake --build "$ZLIB_BUILD_DIR"
cmake --install "$ZLIB_BUILD_DIR"
