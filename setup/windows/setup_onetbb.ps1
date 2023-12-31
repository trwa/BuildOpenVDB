$ONETBB_SRC_DIR = Join-Path "$PSScriptRoot" "/vendor/oneTBB"
$ONETBB_BUILD_DIR = Join-Path "$PSScriptRoot" "/build/oneTBB"
$ONETBB_INSTALL_DIR = Join-Path "$PSScriptRoot" "/libs"

rm -Recurse -Force "$ONETBB_BUILD_DIR"
mkdir "$ONETBB_BUILD_DIR" -ea 0

# docs:
# https://oneapi-src.github.io/oneTBB/main/tbb_userguide/Debug_Versus_Release_Libraries.html

cmake                                            `
    -DCMAKE_BUILD_TYPE=Debug                     `
    -DCMAKE_INSTALL_PREFIX="$ONETBB_INSTALL_DIR" `
    -DTBB_TEST=OFF                               `
    -DTBB_DISABLE_HWLOC_AUTOMATIC_SEARCH=TRUE    `
    -B "$ONETBB_BUILD_DIR"                       `
    -S "$ONETBB_SRC_DIR"                         `
    --fresh

#cmake --build "$ONETBB_BUILD_DIR" --config Release
cmake --build "$ONETBB_BUILD_DIR" --config Debug
cmake --install "$ONETBB_BUILD_DIR" --config Debug
