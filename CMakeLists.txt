cmake_minimum_required(VERSION 3.27.4) # 3.27.4 is required by Boost 1.83.0
project("build_openvdb" LANGUAGES CXX)

include(ExternalProject)

set(CUSTOM_WORKDIR "${CMAKE_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}")
set(CUSTOM_BUILD_PATH "${CUSTOM_WORKDIR}/_deps")
set(CUSTOM_PREFIX_PATH "${CUSTOM_WORKDIR}/_install")
set(CUSTOM_VENDOR_PATH "${CMAKE_SOURCE_DIR}/vendor")

ExternalProject_Add(build_zlib
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

ExternalProject_Add(build_blosc
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
ExternalProject_Add(build_boost
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

ExternalProject_Add(build_tbb
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

ExternalProject_Add(build_openvdb
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
        -DOPENVDB_INSTALL_CMAKE_MODULES=ON

        -DOPENVDB_BUILD_CORE=ON
        -DOPENVDB_BUILD_BINARIES=OFF

        -DOPENVDB_CORE_STATIC=OFF
        -DOPENVDB_CORE_SHARED=ON

        -DBlosc_ROOT=<INSTALL_DIR>
        -DBLOSC_INCLUDEDIR=<INSTALL_DIR>/include
        -DBLOSC_LIBRARYDIR=<INSTALL_DIR>/lib
        -DBLOSC_USE_STATIC_LIBS=ON

        -DBoost_ROOT=<INSTALL_DIR>
        -DBOOST_INCLUDEDIR=<INSTALL_DIR>/include
        -DBOOST_LIBRARYDIR=<INSTALL_DIR>/lib
        -DBOOST_USE_STATIC_LIBS=ON

        -DTBB_ROOT=<INSTALL_DIR>
        -DTBB_INCLUDEDIR=${CUSTOM_PREFIX_PATH}/include
        -DTBB_LIBRARYDIR=${CUSTOM_PREFIX_PATH}/lib
        -DTBB_USE_STATIC_LIBS=OFF

        -DZLIB_ROOT=<INSTALL_DIR>
        -DZLIB_INCLUDEDIR=${CUSTOM_PREFIX_PATH}/include
        -DZLIB_LIBRARYDIR=${CUSTOM_PREFIX_PATH}/lib
        -DZLIB_USE_STATIC_LIBS=ON

        -DUSE_STATIC_DEPENDENCIES=OFF
        #-DUSE_EXPLICIT_INSTANTIATION=OFF

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
    set(BOOST_INCLUDEDIR "${CUSTOM_PREFIX_PATH}/include")
    set(BOOST_LIBRARYDIR "${CUSTOM_PREFIX_PATH}/lib")
    set(BOOST_USE_STATIC_LIBS ON)

    set(Blosc_ROOT "${CUSTOM_PREFIX_PATH}")
    set(BLOSC_INCLUDEDIR "${CUSTOM_PREFIX_PATH}/include")
    set(BLOSC_LIBRARYDIR "${CUSTOM_PREFIX_PATH}/lib")
    set(BLOSC_USE_STATIC_LIBS ON)

    set(TBB_ROOT "${CUSTOM_PREFIX_PATH}")
    set(TBB_INCLUDEDIR "${CUSTOM_PREFIX_PATH}/include")
    set(TBB_LIBRARYDIR "${CUSTOM_PREFIX_PATH}/lib")
    set(TBB_USE_STATIC_LIBS OFF)

    set(ZLIB_ROOT "${CUSTOM_PREFIX_PATH}")
    set(ZLIB_INCLUDEDIR "${CUSTOM_PREFIX_PATH}/include")
    set(ZLIB_LIBRARYDIR "${CUSTOM_PREFIX_PATH}/lib")
    set(ZLIB_USE_STATIC_LIBS ON)

    set(USE_BLOSC TRUE)
    set(USE_ZLIB TRUE)

    set(OPENVDB_USE_STATIC_DEPENDENCIES OFF)

    find_package(OpenVDB REQUIRED)
endfunction()

add_dependencies(build_openvdb build_blosc build_boost build_tbb build_zlib)

# This will fail if the build_* targets are not built
FindOpenVDB()

# Test program compilation
add_subdirectory(test)
