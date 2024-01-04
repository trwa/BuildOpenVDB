cmake_minimum_required(VERSION 3.27)

#project(build_openvdb)

#set(CMAKE_CXX_STANDARD 20)

#set(CMAKE_PREFIX_PATH "${PROJECT_SOURCE_DIR}/install")
#set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/install/lib/cmake/OpenVDB")
#set(USE_STATIC_DEPENDENCIES ON)
#find_package(OpenVDB REQUIRED)


project(build_openvdb)

include(ExternalProject)
# set(CMAKE_CXX_STANDARD 20)

# Blosc
#set(BUILD_STATIC ON CACHE INTERNAL "" FORCE)
#set(BUILD_SHARED OFF CACHE INTERNAL "" FORCE)
#set(BUILD_TESTS OFF CACHE INTERNAL "" FORCE)
#set(BUILD_FUZZERS OFF CACHE INTERNAL "" FORCE)
#set(BUILD_BENCHMARKS OFF CACHE INTERNAL "" FORCE)
#add_subdirectory(c-blosc)

ExternalProject_Add(blosc
        SOURCE_DIR
            "${CMAKE_CURRENT_SOURCE_DIR}/c-blosc"
        CMAKE_ARGS
            -DBUILD_STATIC=ON
            -DBUILD_SHARED=OFF
            -DBUILD_TESTS=OFF
            -DBUILD_FUZZERS=OFF
            -DBUILD_BENCHMARKS=OFF
        BINARY_DIR
            "${CMAKE_CURRENT_SOURCE_DIR}/build/c-blosc"
        INSTALL_DIR
            "${CMAKE_CURRENT_SOURCE_DIR}/install"
)

#[===[
# Boost
set(BOOST_INCLUDE_LIBRARIES "interprocess;iostreams;system")
set(BUILD_STATIC ON CACHE INTERNAL "" FORCE)
set(BUILD_SHARED OFF CACHE INTERNAL "" FORCE)
set(BUILD_TESTS OFF CACHE INTERNAL "" FORCE)
set(BOOST_IOSTREAMS_ENABLE_ZLIB OFF CACHE INTERNAL "" FORCE)
add_subdirectory(boost)

# OneTBB
cmake_policy(SET CMP0077 NEW)
set(BUILD_SHARED_LIBS ON CACHE INTERNAL "" FORCE)
set(TBB_DISABLE_HWLOC_AUTOMATIC_SEARCH ON CACHE INTERNAL "" FORCE)
set(TBB_TEST OFF CACHE INTERNAL "" FORCE)
add_subdirectory(oneTBB)

# Zlib
set(BUILD_SHARED_LIBS OFF CACHE INTERNAL "" FORCE)
add_subdirectory(zlib)
#]===]

#install(TARGETS blosc)

#[===[
add_library(build_openvdb STATIC library.cpp)
target_link_libraries(build_openvdb
        PUBLIC
        blosc_static
        boost_iostreams
        boost_system
        TBB::tbb
        zlibstatic
)

add_executable(build_openvdb_test test.cpp)
target_link_libraries(build_openvdb_test PRIVATE build_openvdb)


add_executable(build_openvdb test.cpp vdb.cpp)
target_link_libraries(build_openvdb OpenVDB::openvdb)
#]===]