cmake_minimum_required(VERSION 3.27)

# https://github.com/Sarcasm/cmake-superbuild.git
option(USE_SUPERBUILD "Whether or not a superbuild should be invoked" ON)

set(MY_SOURCE_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}")

if (USE_SUPERBUILD)
    set(MY_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/_install")
    set(MY_BUILD_PREFIX "${CMAKE_BINARY_DIR}/_build")
else ()
    set(MY_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")
    set(MY_BUILD_PREFIX "${CMAKE_BINARY_DIR}")
endif ()

message(STATUS "MY_SOURCE_PREFIX: ${MY_SOURCE_PREFIX}")
message(STATUS "MY_BUILD_PREFIX: ${MY_BUILD_PREFIX}")
message(STATUS "MY_INSTALL_PREFIX: ${MY_INSTALL_PREFIX}")

if (USE_SUPERBUILD)
    project(SUPERBUILD NONE)
    include(cmake/SuperBuild.cmake)
    return()
else ()
    project(build_openvdb)

    set(DISABLE_CMAKE_SEARCH_PATHS TRUE)
    set(CMAKE_MODULE_PATH "${MY_INSTALL_PREFIX}/lib/cmake/OpenVDB")
    set(CMAKE_PREFIX_PATH "${MY_INSTALL_PREFIX}")

    set(USE_PKGCONFIG FALSE)

    # set(OpenVDB_ROOT "${MY_INSTALL_PREFIX}")
    set(Boost_ROOT "${MY_INSTALL_PREFIX}")
    set(Blosc_ROOT "${MY_INSTALL_PREFIX}")
    set(BLOSC_ROOT "${MY_INSTALL_PREFIX}")
    set(TBB_ROOT "${MY_INSTALL_PREFIX}")
    set(ZLIB_ROOT "${MY_INSTALL_PREFIX}")

    set(USE_BLOSC TRUE)
    set(USE_ZLIB TRUE)

    set(Boost_USE_STATIC_LIBS TRUE)
    set(TBB_USE_STATIC_LIBS FALSE)

    set(OPENVDB_USE_STATIC_LIBS FALSE)
    set(OPENVDB_USE_STATIC_DEPENDENCIES FALSE)

    find_package(OpenVDB REQUIRED)

    add_subdirectory(test)
endif ()
