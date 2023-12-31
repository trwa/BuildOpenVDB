$BOOST_SRC_DIR = Join-Path "$PSScriptRoot" "/vendor/boost"
#$BOOST_BUILD_DIR = Join-Path "$PSScriptRoot" "/build/boost"
$BOOST_INSTALL_DIR = Join-Path "$PSScriptRoot" "/libs"

$BI_SRC_DIR = "$PSScriptRoot"

cd "$BOOST_SRC_DIR"

./bootstrap.bat
./b2 variant=release link=static threading=multi install --prefix="$BOOST_INSTALL_DIR" --with-iostreams --with-system

cd "$BI_SRC_DIR"