$ROOT_DIR = Join-Path "$PSScriptRoot" "/../.."

$OPENVDB_SRC_DIR = Join-Path "$ROOT_DIR" "/openvdb"
$OPENVDB_BUILD_DIR = Join-Path "$ROOT_DIR" "/build/openvdb"
$OPENVDB_INSTALL_DIR = Join-Path "$ROOT_DIR" "/libs"

rm -Recurse -Force "$OPENVDB_BUILD_DIR" -ea 0
mkdir "$OPENVDB_BUILD_DIR" -ea 0

cmake                                             `
    -DCMAKE_INSTALL_PREFIX="$OPENVDB_INSTALL_DIR" `
    -DOPENVDB_BUILD_CORE=ON                       `
    -DOPENVDB_INSTALL_CMAKE_MODULES=ON            `
    -DOPENVDB_CORE_STATIC=ON                      `
    -DOPENVDB_CORE_SHARED=ON                      `
    -DOPENVDB_BUILD_BINARIES=OFF                  `
    -DUSE_STATIC_DEPENDENCIES=OFF                 `
    -DTBB_ROOT="$OPENVDB_INSTALL_DIR"             `
    -DTBB_USE_STATIC_LIBS=OFF                     `
    -DBoost_ROOT="$OPENVDB_INSTALL_DIR"           `
    -DBoost_USE_STATIC_LIBS=ON                    `
    -DUSE_BLOSC=ON                                `
    -DBLOSC_ROOT="$OPENVDB_INSTALL_DIR"           `
    -DUSE_ZLIB=ON                                 `
    -DZLIB_ROOT="$OPENVDB_INSTALL_DIR"            `
    -DUSE_PKGCONFIG=OFF                           `
    -B "$OPENVDB_BUILD_DIR"                       `
    -S "$OPENVDB_SRC_DIR"                         `
    --fresh

cmake --build "$OPENVDB_BUILD_DIR" --config Release --parallel 6
cmake --install "$OPENVDB_BUILD_DIR"
