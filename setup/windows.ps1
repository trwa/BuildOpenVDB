$ROOT_DIR = Join-Path "$PSScriptRoot" "/.."

$SRC_DIR = "$ROOT_DIR"
$BUILD_DIR = Join-Path "$ROOT_DIR" "/build/main"
$INSTALL_DIR = Join-Path "$ROOT_DIR" "/install"

Remove-Item -Recurse -Force "$BUILD_DIR"
mkdir "$BUILD_DIR" -ea 0

cmake                                         `
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"     `
    -B "$BUILD_DIR"                    `
    -S "$SRC_DIR"                      `
    --fresh

#cmake --build "$BUILD_DIR" --config Debug
cmake --build "$BUILD_DIR" --config Release
#cmake --install "$BUILD_DIR"
