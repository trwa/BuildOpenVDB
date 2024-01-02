$ROOT_DIR = Join-Path "$PSScriptRoot" "/../.."

$BOOST_SRC_DIR = Join-Path "$ROOT_DIR" "/boost"
$BOOST_INSTALL_DIR = Join-Path "$ROOT_DIR" "/libs"

Set-Location "$BOOST_SRC_DIR"

./bootstrap.bat
./b2 variant=release link=static threading=multi install --prefix="$BOOST_INSTALL_DIR" --with-iostreams --with-system

Set-Location "$ROOT_DIR"
