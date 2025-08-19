cmake_minimum_required(VERSION 3.31)
project(konch_samples LANGUAGES CXX CUDA)

include(../cmake/cuda_compile_commands.cmake)

add_subdirectory(mlp)
