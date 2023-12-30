# Build OpenVDB

This is a (hopefully) sensible build of ASFW's [OpenVDB](https://www.openvdb.org/) library for sparse volumetric data. 
Differently from what suggested in the [official README](https://github.com/AcademySoftwareFoundation/openvdb), this repo assumes no system dependencies other than [git](https://git-scm.com/), [CMake](https://cmake.org/) and a suitable C++ toolchain.
Thus, it makes it suitable for self-contained use (for example, as a submodule in your project).

## Supported OSes

* Windows
* (Arch) Linux

## About the LICENSE

Since this repo is merely "glue" over code of others, I have chosen to inherit the most restrictive license of all the dependent projects.
However, IANAL, so feel free to raise an issue if you believe that this should be changed.
