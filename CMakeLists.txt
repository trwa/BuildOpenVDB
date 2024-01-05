cmake_minimum_required(VERSION 3.27.4) # 3.27.4 is required by Boost 1.83.0
project("build-openvdb" LANGUAGES CXX)

include(ExternalProject)

set(CUSTOM_WORKDIR "${CMAKE_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}")
set(CUSTOM_BUILD_PATH "${CUSTOM_WORKDIR}/_deps")
set(CUSTOM_PREFIX_PATH "${CUSTOM_WORKDIR}/_install")
set(CUSTOM_VENDOR_PATH "${CMAKE_SOURCE_DIR}/vendor")

ExternalProject_Add(ep_zlib
        SOURCE_DIR
        "${CUSTOM_VENDOR_PATH}/zlib"

        BINARY_DIR
        "${CUSTOM_BUILD_PATH}/zlib"

        INSTALL_DIR
        "${CUSTOM_PREFIX_PATH}"

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON # https://github.com/google/glog/issues/983#issuecomment-1845388247
)

ExternalProject_Add(ep_blosc
        SOURCE_DIR
        "${CUSTOM_VENDOR_PATH}/c-blosc"

        BINARY_DIR
        "${CUSTOM_BUILD_PATH}/c-blosc"

        INSTALL_DIR
        "${CUSTOM_PREFIX_PATH}"

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON # https://github.com/google/glog/issues/983#issuecomment-1845388247
        -DBUILD_STATIC=ON
        -DBUILD_SHARED=OFF
        -DBUILD_TESTS=OFF
        -DBUILD_FUZZERS=OFF
        -DBUILD_BENCHMARKS=OFF
)

# Separator trick: https://stackoverflow.com/a/45433229
set(MY_BOOST_LIBRARIES "interprocess;iostreams;system")
string(REPLACE ";" "|" MY_BOOST_LIBRARIES_ALT_SEP "${MY_BOOST_LIBRARIES}")
ExternalProject_Add(ep_boost
        SOURCE_DIR
        "${CUSTOM_VENDOR_PATH}/boost"

        BINARY_DIR
        "${CUSTOM_BUILD_PATH}/boost"

        INSTALL_DIR
        "${CUSTOM_PREFIX_PATH}"

        LIST_SEPARATOR |

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON # https://github.com/google/glog/issues/983#issuecomment-1845388247
        -DCMAKE_MODULE_PATH=<INSTALL_DIR>
        -DBOOST_INCLUDE_LIBRARIES=${MY_BOOST_LIBRARIES_ALT_SEP}
        -DBOOST_IOSTREAMS_ENABLE_ZLIB=OFF
        -DBOOST_IOSTREAMS_ENABLE_BZIP2=OFF
        -DBOOST_IOSTREAMS_ENABLE_LZMA=OFF
        -DBOOST_IOSTREAMS_ENABLE_ZSTD=OFF
        -DBUILD_SHARED_LIBS=OFF
)

ExternalProject_Add(ep_tbb
        SOURCE_DIR
        "${CUSTOM_VENDOR_PATH}/oneTBB"

        BINARY_DIR
        "${CUSTOM_BUILD_PATH}/tbb"

        INSTALL_DIR
        "${CUSTOM_PREFIX_PATH}"

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON # https://github.com/google/glog/issues/983#issuecomment-1845388247
        -DBUILD_SHARED_LIBS=ON
        -DTBB_TEST=OFF
        -DTBB_DISABLE_HWLOC_AUTOMATIC_SEARCH=TRUE
)

ExternalProject_Add(ep_openvdb
        SOURCE_DIR
        "${CUSTOM_VENDOR_PATH}/openvdb"

        BINARY_DIR
        "${CUSTOM_BUILD_PATH}/openvdb"

        INSTALL_DIR
        "${CUSTOM_PREFIX_PATH}"

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON # https://github.com/google/glog/issues/983#issuecomment-1845388247
        -DDISABLE_CMAKE_SEARCH_PATHS=ON
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
        #-DUSE_EXPLICIT_INSTANTIATION=OFF
        -DBOOST_USE_STATIC_LIBS=ON
        #-DTBB_USE_STATIC_LIBS=OFF
        #-DBLOSC_USE_STATIC_LIBS=ON
        -DZLIB_USE_STATIC_LIBS=ON
        -DUSE_BLOSC=ON
        -DUSE_ZLIB=ON
        -DUSE_PKGCONFIG=OFF
)

function(FindOpenVDB)
    set(DISABLE_CMAKE_SEARCH_PATHS TRUE)
    set(CMAKE_MODULE_PATH "${CUSTOM_PREFIX_PATH}/lib/cmake/OpenVDB")
    set(CMAKE_PREFIX_PATH "${CUSTOM_PREFIX_PATH}")

    set(USE_PKGCONFIG FALSE)

    # set(OpenVDB_ROOT "${MY_INSTALL_PREFIX}")
    set(Boost_ROOT "${CUSTOM_PREFIX_PATH}")
    set(Blosc_ROOT "${CUSTOM_PREFIX_PATH}")
    set(BLOSC_ROOT "${CUSTOM_PREFIX_PATH}")
    set(TBB_ROOT "${CUSTOM_PREFIX_PATH}")
    set(ZLIB_ROOT "${CUSTOM_PREFIX_PATH}")

    set(USE_BLOSC TRUE)
    set(USE_ZLIB TRUE)

    set(Boost_USE_STATIC_LIBS TRUE)
    set(TBB_USE_STATIC_LIBS FALSE)

    set(OPENVDB_USE_STATIC_LIBS FALSE)
    set(OPENVDB_USE_STATIC_DEPENDENCIES FALSE)

    find_package(OpenVDB REQUIRED)
endfunction()

# This will fail if the ep_* targets are not built
FindOpenVDB()

# Test program compilation
add_subdirectory(test)
