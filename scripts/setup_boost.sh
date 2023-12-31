#!/usr/bin/env bash

BOOST_SRC_DIR="$PWD"/vendor/boost
BOOST_INSTALL_DIR="$PWD"/libs

BI_SRC_DIR="$PWD"

cd "$BOOST_SRC_DIR" || exit

./bootstrap.sh --prefix="$BOOST_INSTALL_DIR" --with-libraries=iostreams,system
./b2 variant=release link=static threading=multi install

cd "$BI_SRC_DIR" || exit
