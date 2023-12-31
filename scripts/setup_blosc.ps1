$BLOSC_SRC_DIR = Join-Path "$PSScriptRoot" "/vendor/c-blosc"
$BLOSC_BUILD_DIR = Join-Path "$PSScriptRoot" "/build/c-blosc"
$BLOSC_INSTALL_DIR = Join-Path "$PSScriptRoot" "/libs"

rm -Recurse -Force "$BLOSC_BUILD_DIR" -ea 0
mkdir "$BLOSC_BUILD_DIR" -ea 0

cmake                                           `
    -DCMAKE_INSTALL_PREFIX="$BLOSC_INSTALL_DIR" `
    -B "$BLOSC_BUILD_DIR"                       `
    -S "$BLOSC_SRC_DIR"                         `
    --fresh

#cmake --build "$ONETBB_BUILD_DIR" --config Release
cmake --build "$BLOSC_BUILD_DIR" --config Debug
cmake --install "$BLOSC_BUILD_DIR" --config Debug
