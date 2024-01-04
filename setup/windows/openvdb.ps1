$ROOT_DIR = Join-Path "$PSScriptRoot" "/../.."

$OPENVDB_SRC_DIR = Join-Path "$ROOT_DIR" "/openvdb"
$OPENVDB_BUILD_DIR = Join-Path "$ROOT_DIR" "/build/openvdb"
$OPENVDB_INSTALL_DIR = Join-Path "$ROOT_DIR" "/libs"

rm -Recurse -Force "$OPENVDB_BUILD_DIR" -ea 0
mkdir "$OPENVDB_BUILD_DIR" -ea 0

cmake                                             `
    -DCMAKE_INSTALL_PREFIX="$OPENVDB_INSTALL_DIR" `
    -DOPENVDB_BUILD_CORE=ON                       `
    -DOPENVDB_BUILD_BINARIES=OFF                  `
    -DOPENVDB_CORE_STATIC=ON                      `
    -DOPENVDB_CORE_SHARED=OFF                     `
    -DOPENVDB_INSTALL_CMAKE_MODULES=ON            `
    -DBLOSC_ROOT="$OPENVDB_INSTALL_DIR"           `
    -DBoost_ROOT="$OPENVDB_INSTALL_DIR"           `
    -DTBB_ROOT="$OPENVDB_INSTALL_DIR"             `
    -DTBB_LIBRARYDIR="$OPENVDB_INSTALL_DIR/lib"   `
    -DZLIB_ROOT="$OPENVDB_INSTALL_DIR"            `
    -DUSE_STATIC_DEPENDENCIES=ON                  `
    -DUSE_EXPLICIT_INSTANTIATION=OFF              `
    -DBoost_USE_STATIC_LIBS=ON                    `
    -DTBB_USE_STATIC_LIBS=ON                      `
    -DUSE_BLOSC=ON                                `
    -DUSE_ZLIB=ON                                 `
    -DUSE_PKGCONFIG=OFF                           `
    -B "$OPENVDB_BUILD_DIR"                       `
    -S "$OPENVDB_SRC_DIR"                         `
    --fresh

cmake --build "$OPENVDB_BUILD_DIR" --config Debug --parallel 6
cmake --install "$OPENVDB_BUILD_DIR" --config Debug
