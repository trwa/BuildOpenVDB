#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

BOOST_SRC_DIR="$SCRIPT_DIR"/../boost
BOOST_INSTALL_DIR="$SCRIPT_DIR"/../libs

BI_SRC_DIR="$PWD"

cd "$BOOST_SRC_DIR" || exit

./bootstrap.sh --prefix="$BOOST_INSTALL_DIR" --with-libraries=iostreams,system
./b2 variant=release link=static threading=multi install

cd "$BI_SRC_DIR" || exit
