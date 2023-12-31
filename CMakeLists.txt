cmake_minimum_required(VERSION 3.27)
project(build_openvdb)

set(CMAKE_CXX_STANDARD 20)

add_library(build_openvdb STATIC library.cpp)
