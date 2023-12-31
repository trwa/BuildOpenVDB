#!/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR="$SCRIPT_DIR"/../..

OPENVDB_SRC_DIR="$ROOT_DIR"/openvdb
OPENVDB_BUILD_DIR="$ROOT_DIR"/build/openvdb
OPENVDB_INSTALL_DIR="$ROOT_DIR"/libs

rm -r "$OPENVDB_BUILD_DIR"
mkdir -p "$OPENVDB_BUILD_DIR"

cmake                                           \
  -DCMAKE_INSTALL_PREFIX="$OPENVDB_INSTALL_DIR" \
  -DOPENVDB_BUILD_CORE=ON                       \
  -DOPENVDB_INSTALL_CMAKE_MODULES=ON            \
  -DOPENVDB_CORE_STATIC=OFF                     \
  -DOPENVDB_CORE_SHARED=ON                      \
  -DOPENVDB_BUILD_BINARIES=OFF                  \
  -DUSE_STATIC_DEPENDENCIES=OFF                 \
  -DTBB_ROOT="$OPENVDB_INSTALL_DIR"             \
  -DBoost_ROOT="$OPENVDB_INSTALL_DIR"           \
  -DBoost_USE_STATIC_LIBS=ON                    \
  -DUSE_BLOSC=ON                                \
  -DBlosc_ROOT="$OPENVDB_INSTALL_DIR"           \
  -DUSE_ZLIB=ON                                 \
  -DZLIB_ROOT="$OPENVDB_INSTALL_DIR"            \
  -DUSE_PKGCONFIG=OFF                           \
  -B "$OPENVDB_BUILD_DIR"                       \
  -S "$OPENVDB_SRC_DIR"                         \
  --fresh

cmake --build "$OPENVDB_BUILD_DIR" --parallel 6 # TODO: njobs should be a parameter
cmake --install "$OPENVDB_BUILD_DIR"
