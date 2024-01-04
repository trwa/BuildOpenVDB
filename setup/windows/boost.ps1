$ROOT_DIR = Join-Path "$PSScriptRoot" "/../.."

$BOOST_SRC_DIR = Join-Path "$ROOT_DIR" "/boost"
$BOOST_BUILD_DIR = Join-Path "$ROOT_DIR" "/build/boost"
$BOOST_INSTALL_DIR = Join-Path "$ROOT_DIR" "/install"

Remove-Item -Recurse -Force "$BOOST_BUILD_DIR" -ea 0
mkdir "$BOOST_BUILD_DIR" -ea 0

cmake                                                   `
    -DCMAKE_INSTALL_PREFIX="$BOOST_INSTALL_DIR"         `
    -DBOOST_INCLUDE_LIBRARIES="interprocess;iostreams"  `
    -B "$BOOST_BUILD_DIR"                               `
    -S "$BOOST_SRC_DIR"                                 `
    --fresh

#cmake --build "$BOOST_BUILD_DIR" --config Debug
cmake --build "$BOOST_BUILD_DIR" --config Release
cmake --install "$BOOST_BUILD_DIR"
