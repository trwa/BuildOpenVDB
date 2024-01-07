# Build OpenVDB

This is a (hopefully) sensible build of ASFW's [OpenVDB](https://www.openvdb.org/) library for sparse volumetric data. 
Differently from what suggested in the [official README](https://github.com/AcademySoftwareFoundation/openvdb), this repo assumes no system dependencies other than [git](https://git-scm.com/), [CMake](https://cmake.org/) and a suitable C++ toolchain.
For any references, here's the [link to the official documentation](https://www.openvdb.org/documentation/doxygen/build.html).

## Build Artifacts
This build produces two shared libraries (`openvdb` and `tbb`).
Other dependencies are statically linked into `openvdb`.

## Supported Platforms

- [x] Linux g++ (GCC) 13.2.1
  - [x] Debug
  - [x] Release
- [ ] Windows MSVC 
  - [ ] Debug
  - [x] Release
- [ ] Windows MinGW
  - [ ] Debug
  - [ ] Release

## About the LICENSE

Since this repo is merely a few lines of CMake "glue" over the code of others, I have chosen to inherit the most restrictive license of all the dependent projects.
However, IANAL, so feel free to raise an issue if you believe that this should be changed.
