include(ExternalProject)

ExternalProject_Add(my_blosc
        SOURCE_DIR
        "${MY_SOURCE_PREFIX}/c-blosc"

        BINARY_DIR
        "${MY_BUILD_PREFIX}/c-blosc"

        INSTALL_DIR
        "${MY_INSTALL_PREFIX}"

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        #-DCMAKE_POSITION_INDEPENDENT_CODE=ON # https://github.com/google/glog/issues/983#issuecomment-1845388247
        -DBUILD_STATIC=OFF
        -DBUILD_SHARED=ON
        -DBUILD_TESTS=OFF
        -DBUILD_FUZZERS=OFF
        -DBUILD_BENCHMARKS=OFF
)

# Separator trick: https://stackoverflow.com/a/45433229
set(MY_BOOST_LIBRARIES "interprocess;iostreams;system")
string(REPLACE ";" "|" MY_BOOST_LIBRARIES_ALT_SEP "${MY_BOOST_LIBRARIES}")
ExternalProject_Add(my_boost
        SOURCE_DIR
        "${MY_SOURCE_PREFIX}/boost"

        BINARY_DIR
        "${MY_BUILD_PREFIX}/boost"

        INSTALL_DIR
        "${MY_INSTALL_PREFIX}"

        LIST_SEPARATOR |

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DBOOST_INCLUDE_LIBRARIES=${MY_BOOST_LIBRARIES_ALT_SEP}
        -DBUILD_SHARED_LIBS=ON
)

ExternalProject_Add(my_zlib
        SOURCE_DIR
        "${MY_SOURCE_PREFIX}/zlib"

        BINARY_DIR
        "${MY_BUILD_PREFIX}/zlib"

        INSTALL_DIR
        "${MY_INSTALL_PREFIX}"

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS=ON
)

ExternalProject_Add(my_tbb
        SOURCE_DIR
        "${MY_SOURCE_PREFIX}/oneTBB"

        BINARY_DIR
        "${MY_BUILD_PREFIX}/tbb"

        INSTALL_DIR
        "${MY_INSTALL_PREFIX}"

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS=ON
        -DTBB_TEST=OFF
        -DTBB_DISABLE_HWLOC_AUTOMATIC_SEARCH=TRUE
)

ExternalProject_Add(my_openvdb
        SOURCE_DIR
        "${MY_SOURCE_PREFIX}/openvdb"

        BINARY_DIR
        "${MY_BUILD_PREFIX}/openvdb"

        INSTALL_DIR
        "${MY_INSTALL_PREFIX}"

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DOPENVDB_BUILD_CORE=ON
        -DOPENVDB_BUILD_BINARIES=OFF
        -DOPENVDB_CORE_STATIC=OFF
        -DOPENVDB_CORE_SHARED=ON
        -DOPENVDB_INSTALL_CMAKE_MODULES=ON
        -DBlosc_ROOT=<INSTALL_DIR>
        -DBoost_ROOT=<INSTALL_DIR>
        -DTBB_ROOT=<INSTALL_DIR>
        -DZLIB_ROOT=<INSTALL_DIR>
        -DUSE_STATIC_DEPENDENCIES=OFF
        -DUSE_EXPLICIT_INSTANTIATION=OFF
        #-DBOOST_USE_STATIC_LIBS=OFF
        #-DTBB_USE_STATIC_LIBS=OFF
        #-DBLOSC_USE_STATIC_LIBS=OFF
        #-DZLIB_USE_STATIC_LIBS=OFF
        -DUSE_BLOSC=ON
        -DUSE_ZLIB=ON
        -DUSE_PKGCONFIG=OFF
)

ExternalProject_Add(test
        SOURCE_DIR
        "${MY_SOURCE_PREFIX}"

        BINARY_DIR
        "${MY_BUILD_PREFIX}/test"

        INSTALL_DIR
        "${MY_INSTALL_PREFIX}"

        CMAKE_ARGS
        -DUSE_SUPERBUILD=OFF
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
)
