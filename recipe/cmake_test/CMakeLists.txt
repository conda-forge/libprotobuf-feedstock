project(cf_dummy LANGUAGES C CXX)
cmake_minimum_required(VERSION 3.12)
# CMake seems to prefer its own FindProtobuf to the
# protobuf-config.cmake being distributed by this
# feedstock; make sure things work
find_package(Protobuf REQUIRED)
