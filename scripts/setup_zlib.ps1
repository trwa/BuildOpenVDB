$ZLIB_SRC_DIR = Join-Path "$PSScriptRoot" "/vendor/zlib"
$ZLIB_BUILD_DIR = Join-Path "$PSScriptRoot" "/build/zlib"
$ZLIB_INSTALL_DIR = Join-Path "$PSScriptRoot" "/libs"

rm -Recurse -Force "$ZLIB_BUILD_DIR"
mkdir "$ZLIB_BUILD_DIR" -ea 0

cmake                                          `
    -DCMAKE_INSTALL_PREFIX="$ZLIB_INSTALL_DIR" `
    -DBUILD_SHARED_LIBS=TRUE                   `
    -B "$ZLIB_BUILD_DIR"                       `
    -S "$ZLIB_SRC_DIR"                         `
    --fresh

cmake --build "$ZLIB_BUILD_DIR" --config Release
cmake --install "$ZLIB_BUILD_DIR"
