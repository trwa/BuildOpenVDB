cmake_minimum_required(VERSION 3.27.4) # 3.27.4 is required by Boost 1.83.0
project("build_openvdb" LANGUAGES CXX)

include(ExternalProject)

# Installation directory has to be global, to be used by the function that finds OpenVDB
# (CMake lacks "closure" semantics https://stackoverflow.com/a/69913861/20683133)
set(BUILD_OPENVDB_PREFIX_PATH "${CMAKE_CURRENT_BINARY_DIR}/_install" CACHE INTERNAL "Install prefix for OpenVDB")

# Build directories are located here
set(BUILD_OPENVDB_BUILD_PATH "${CMAKE_CURRENT_BINARY_DIR}/_deps")

# Source directories are located here
set(BUILD_OPENVDB_VENDOR_PATH "${CMAKE_CURRENT_SOURCE_DIR}/vendor")

ExternalProject_Add(BuildZlib
        SOURCE_DIR
        "${BUILD_OPENVDB_VENDOR_PATH}/zlib"

        BINARY_DIR
        "${BUILD_OPENVDB_BUILD_PATH}/zlib"

        INSTALL_DIR
        "${BUILD_OPENVDB_PREFIX_PATH}"

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON # https://github.com/google/glog/issues/983#issuecomment-1845388247
)

ExternalProject_Add(BuildBlosc
        SOURCE_DIR
        "${BUILD_OPENVDB_VENDOR_PATH}/c-blosc"

        BINARY_DIR
        "${BUILD_OPENVDB_BUILD_PATH}/c-blosc"

        INSTALL_DIR
        "${BUILD_OPENVDB_PREFIX_PATH}"

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
set(BUILD_OPENVDB_BOOST_LIBRARIES "interprocess;iostreams;system")
string(REPLACE ";" "|" BUILD_OPENVDB_BOOST_LIBRARIES_ALT_SEP "${BUILD_OPENVDB_BOOST_LIBRARIES}")
ExternalProject_Add(BuildBoost
        SOURCE_DIR
        "${BUILD_OPENVDB_VENDOR_PATH}/boost"

        BINARY_DIR
        "${BUILD_OPENVDB_BUILD_PATH}/boost"

        INSTALL_DIR
        "${BUILD_OPENVDB_PREFIX_PATH}"

        LIST_SEPARATOR |

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON # https://github.com/google/glog/issues/983#issuecomment-1845388247
        -DCMAKE_MODULE_PATH=<INSTALL_DIR>
        -DBOOST_INCLUDE_LIBRARIES=${BUILD_OPENVDB_BOOST_LIBRARIES_ALT_SEP}
        -DBOOST_IOSTREAMS_ENABLE_ZLIB=OFF
        -DBOOST_IOSTREAMS_ENABLE_BZIP2=OFF
        -DBOOST_IOSTREAMS_ENABLE_LZMA=OFF
        -DBOOST_IOSTREAMS_ENABLE_ZSTD=OFF
        -DBUILD_SHARED_LIBS=OFF
)

ExternalProject_Add(BuildOneTBB
        SOURCE_DIR
        "${BUILD_OPENVDB_VENDOR_PATH}/oneTBB"

        BINARY_DIR
        "${BUILD_OPENVDB_BUILD_PATH}/oneTBB"

        INSTALL_DIR
        "${BUILD_OPENVDB_PREFIX_PATH}"

        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON # https://github.com/google/glog/issues/983#issuecomment-1845388247
        -DBUILD_SHARED_LIBS=ON
        -DTBB_TEST=OFF
        -DTBB_DISABLE_HWLOC_AUTOMATIC_SEARCH=TRUE
)

ExternalProject_Add(BuildOpenVDB
        SOURCE_DIR
        "${BUILD_OPENVDB_VENDOR_PATH}/openvdb"

        BINARY_DIR
        "${BUILD_OPENVDB_BUILD_PATH}/openvdb"

        INSTALL_DIR
        "${BUILD_OPENVDB_PREFIX_PATH}"

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
        -DTBB_INCLUDEDIR=${BUILD_OPENVDB_PREFIX_PATH}/include
        -DTBB_LIBRARYDIR=${BUILD_OPENVDB_PREFIX_PATH}/lib
        -DTBB_USE_STATIC_LIBS=OFF

        -DZLIB_ROOT=<INSTALL_DIR>
        -DZLIB_INCLUDEDIR=${BUILD_OPENVDB_PREFIX_PATH}/include
        -DZLIB_LIBRARYDIR=${BUILD_OPENVDB_PREFIX_PATH}/lib
        -DZLIB_USE_STATIC_LIBS=ON

        -DUSE_STATIC_DEPENDENCIES=OFF
        #-DUSE_EXPLICIT_INSTANTIATION=OFF

        -DUSE_BLOSC=ON
        -DUSE_ZLIB=ON
        -DUSE_PKGCONFIG=OFF
)

# Make sure that OpenVDB is built after its dependencies
add_dependencies(BuildOpenVDB BuildBlosc BuildBoost BuildOneTBB BuildZlib)

function(FindOpenVDB)
    #block(SCOPE_FOR VARIABLES)
    set(DISABLE_CMAKE_SEARCH_PATHS TRUE)
    set(CMAKE_MODULE_PATH "${BUILD_OPENVDB_PREFIX_PATH}/lib64/cmake/OpenVDB")
    set(CMAKE_PREFIX_PATH "${BUILD_OPENVDB_PREFIX_PATH}")

    set(USE_PKGCONFIG FALSE)

    #set(OpenVDB_ROOT "${BUILD_OPENVDB_PREFIX_PATH}")
    set(Boost_ROOT "${BUILD_OPENVDB_PREFIX_PATH}")
    set(BOOST_INCLUDEDIR "${BUILD_OPENVDB_PREFIX_PATH}/include")
    set(BOOST_LIBRARYDIR "${BUILD_OPENVDB_PREFIX_PATH}/lib")
    set(BOOST_USE_STATIC_LIBS ON)

    set(Blosc_ROOT "${BUILD_OPENVDB_PREFIX_PATH}")
    set(BLOSC_INCLUDEDIR "${BUILD_OPENVDB_PREFIX_PATH}/include")
    set(BLOSC_LIBRARYDIR "${BUILD_OPENVDB_PREFIX_PATH}/lib")
    set(BLOSC_USE_STATIC_LIBS ON)

    set(TBB_ROOT "${BUILD_OPENVDB_PREFIX_PATH}")
    set(TBB_INCLUDEDIR "${BUILD_OPENVDB_PREFIX_PATH}/include")
    set(TBB_LIBRARYDIR "${BUILD_OPENVDB_PREFIX_PATH}/lib")
    set(TBB_USE_STATIC_LIBS OFF)

    set(ZLIB_ROOT "${BUILD_OPENVDB_PREFIX_PATH}")
    set(ZLIB_INCLUDEDIR "${BUILD_OPENVDB_PREFIX_PATH}/include")
    set(ZLIB_LIBRARYDIR "${BUILD_OPENVDB_PREFIX_PATH}/lib")
    set(ZLIB_USE_STATIC_LIBS ON)

    set(USE_BLOSC TRUE)
    set(USE_ZLIB TRUE)

    set(OPENVDB_USE_STATIC_DEPENDENCIES OFF)

    find_package(OpenVDB QUIET)
    #set(OpenVDB_FOUND "${OpenVDB_FOUND}" CACHE INTERNAL "OpenVDB_FOUND")
    #endblock()
endfunction()

FindOpenVDB()

if (TARGET OpenVDB::openvdb)
    message(STATUS "OpenVDB found")

    # Add dummy target to test that OpenVDB is usable
    add_subdirectory(test)
else ()
    message(WARNING "OpenVDB not found. Please build target 'BuildOpenVDB' and reload the project.")
endif ()
