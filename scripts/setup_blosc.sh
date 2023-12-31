#!/usr/bin/env bash

BLOSC_SRC_DIR="$PWD"/vendor/c-blosc
BLOSC_BUILD_DIR="$PWD"/build/c-blosc
BLOSC_INSTALL_DIR="$PWD"/libs

rm -rf "$BLOSC_BUILD_DIR"
mkdir -p "$BLOSC_BUILD_DIR"

cmake                                         \
  -DCMAKE_INSTALL_PREFIX="$BLOSC_INSTALL_DIR" \
  -B "$BLOSC_BUILD_DIR"                       \
  -S "$BLOSC_SRC_DIR"                         \
  --fresh

#cmake --build "$BLOSC_BUILD_DIR" --config Debug
cmake --build "$BLOSC_BUILD_DIR" --config Release
cmake --install "$BLOSC_BUILD_DIR" --config Release
