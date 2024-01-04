$ROOT_DIR = Join-Path "$PSScriptRoot" "/../.."

$BOOST_SRC_DIR = Join-Path "$ROOT_DIR" "/boost"
$BOOST_INSTALL_DIR = Join-Path "$ROOT_DIR" "/install"

Set-Location (Join-Path "$BOOST_SRC_DIR" "/tools/build")

./bootstrap.bat
./b2 install --prefix="$BOOST_INSTALL_DIR" variant=release link=static threading=multi --with-iostreams

Set-Location "$ROOT_DIR"
