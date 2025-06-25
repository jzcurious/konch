cmake_minimum_required(VERSION 3.24)
project(konch_benchmarks LANGUAGES CXX)

include(../cmake/gbench.cmake)
include(../cmake/eigen.cmake)

find_package(CUDAToolkit REQUIRED)

file(GLOB_RECURSE SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
)

add_executable(konch_benchmarks ${SRC})

target_include_directories(konch_benchmarks PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include/
)

target_compile_features(konch_benchmarks PRIVATE
    cxx_std_20
)

target_compile_options(konch_benchmarks PRIVATE
    -Wall -O3
)

target_link_libraries(konch_benchmarks PRIVATE
    konch::core
    CUDA::cudart
    benchmark::benchmark
    Eigen3::Eigen
)
