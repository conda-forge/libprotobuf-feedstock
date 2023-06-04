project(cf_dummy LANGUAGES C CXX)
cmake_minimum_required(VERSION 3.12)
# CMake seems to prefer its own FindProtobuf to the
# protobuf-config.cmake being distributed by this
# feedstock; make sure things work
find_package(Protobuf CONFIG REQUIRED)

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/struct_example.cc
"

#include <iostream>

#include <google/protobuf/struct.pb.h>

int main()
{
    google::protobuf::Struct myStruct;
}

"
)

add_executable(struct_example ${CMAKE_CURRENT_BINARY_DIR}/struct_example.cc)
target_link_libraries(struct_example PRIVATE protobuf::libprotobuf)
