cmake_minimum_required(VERSION 3.24)
project(konch_bundle LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(konch)
# add_subdirectory(tests)
# add_subdirectory(benchmarks)

include(cmake/scc.cmake)
