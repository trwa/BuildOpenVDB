cmake_minimum_required(VERSION 3.27)
cmake_policy(SET CMP0077 NEW)

project(build_openvdb)

set(CMAKE_CXX_STANDARD 20)

# Blosc
set(BUILD_STATIC ON)
set(BUILD_SHARED OFF)
set(BUILD_TESTS OFF)
add_subdirectory(c-blosc)

# Boost
set(BOOST_INCLUDE_LIBRARIES "iostreams;system")
set(BUILD_STATIC ON)
set(BUILD_SHARED OFF)
set(BUILD_TESTS OFF)
add_subdirectory(boost)

# OneTBB
set(BUILD_SHARED_LIBS ON)
set(TBB_DISABLE_HWLOC_AUTOMATIC_SEARCH ON)
set(TBB_TEST OFF)
add_subdirectory(oneTBB)

add_library(build_openvdb STATIC library.cpp)
target_link_libraries(build_openvdb
        PRIVATE
        c-blosc
        boost_iostreams
        boost_system
        TBB::tbb
)
