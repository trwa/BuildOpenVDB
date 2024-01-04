add_executable(test test.cpp vdb.cpp)
target_link_libraries(test PUBLIC OpenVDB::openvdb)

install(TARGETS test DESTINATION bin)
