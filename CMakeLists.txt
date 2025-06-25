cmake_minimum_required(VERSION 3.24)
project(hs2025 LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(core)
# add_subdirectory(tests)
# add_subdirectory(benchmarks)

include(cmake/scc.cmake)
