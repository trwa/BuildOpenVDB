cmake_minimum_required(VERSION 3.27)

project(build_openvdb)

set(CMAKE_CXX_STANDARD 20)

set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/libs/lib/cmake/OpenVDB")
find_package(OpenVDB REQUIRED)

add_executable(build_openvdb test.cpp vdb.cpp)
target_link_libraries(build_openvdb OpenVDB::openvdb)
