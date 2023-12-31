#!/bin/env bash

ZLIB_SRC_DIR="$PWD"/vendor/zlib
ZLIB_BUILD_DIR="$PWD"/build/zlib
ZLIB_INSTALL_DIR="$PWD"/libs

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
