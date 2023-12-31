#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR="$SCRIPT_DIR"/../..

BLOSC_SRC_DIR="$ROOT_DIR"/c-blosc
BLOSC_BUILD_DIR="$ROOT_DIR"/build/c-blosc
BLOSC_INSTALL_DIR="$ROOT_DIR"/libs

rm -rf "$BLOSC_BUILD_DIR"
mkdir -p "$BLOSC_BUILD_DIR"

cmake                                         \
  -DCMAKE_INSTALL_PREFIX="$BLOSC_INSTALL_DIR" \
  -B "$BLOSC_BUILD_DIR"                       \
  -S "$BLOSC_SRC_DIR"                         \
  --fresh

cmake --build "$BLOSC_BUILD_DIR" # --config Release
cmake --install "$BLOSC_BUILD_DIR" # --config Release
