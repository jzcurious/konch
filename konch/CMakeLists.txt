cmake_minimum_required(VERSION 3.31)
project(konch LANGUAGES CXX CUDA)

include(../cmake/cuda_compile_commands.cmake)

add_subdirectory(core)
