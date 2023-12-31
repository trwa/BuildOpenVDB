#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

BLOSC_SRC_DIR="$SCRIPT_DIR"/../c-blosc
BLOSC_BUILD_DIR="$SCRIPT_DIR"/../build/c-blosc
BLOSC_INSTALL_DIR="$SCRIPT_DIR"/../libs

rm -rf "$BLOSC_BUILD_DIR"
mkdir -p "$BLOSC_BUILD_DIR"

cmake                                         \
  -DCMAKE_INSTALL_PREFIX="$BLOSC_INSTALL_DIR" \
  -B "$BLOSC_BUILD_DIR"                       \
  -S "$BLOSC_SRC_DIR"                         \
  --fresh

#cmake --build "$BLOSC_BUILD_DIR" --config Debug
cmake --build "$BLOSC_BUILD_DIR" # --config Release
cmake --install "$BLOSC_BUILD_DIR" # --config Release
