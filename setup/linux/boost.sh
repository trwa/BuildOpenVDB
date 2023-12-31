#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR="$SCRIPT_DIR"/../..

BOOST_SRC_DIR="$ROOT_DIR"/boost
BOOST_INSTALL_DIR="$ROOT_DIR"/libs

cd "$BOOST_SRC_DIR" || exit

./bootstrap.sh --prefix="$BOOST_INSTALL_DIR" --with-libraries=iostreams,system
./b2 variant=release link=static threading=multi install

cd "$ROOT_DIR" || exit
