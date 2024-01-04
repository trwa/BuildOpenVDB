$ROOT_DIR = Join-Path "$PSScriptRoot" "/../.."

$BLOSC_SRC_DIR = Join-Path "$ROOT_DIR" "/c-blosc"
$BLOSC_BUILD_DIR = Join-Path "$ROOT_DIR" "/build/c-blosc"
$BLOSC_INSTALL_DIR = Join-Path "$ROOT_DIR" "/install"

Remove-Item -Recurse -Force "$BLOSC_BUILD_DIR" -ea 0
mkdir "$BLOSC_BUILD_DIR" -ea 0

cmake                                           `
    -DCMAKE_INSTALL_PREFIX="$BLOSC_INSTALL_DIR" `
    -DBUILD_STATIC=ON                           `
    -DBUILD_SHARED=OFF                          `
    -DBUILD_TESTS=OFF                           `
    -DBUILD_FUZZERS=OFF                         `
    -DBUILD_BENCHMARKS=OFF                      `
    -B "$BLOSC_BUILD_DIR"                       `
    -S "$BLOSC_SRC_DIR"                         `
    --fresh

cmake --build "$BLOSC_BUILD_DIR" --config Release
cmake --install "$BLOSC_BUILD_DIR"
