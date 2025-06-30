cmake_minimum_required(VERSION 3.24)
project(konch_nn LANGUAGES CXX CUDA)

include(../../cmake/cuda_arch.cmake)

find_package(CUDAToolkit REQUIRED)

set(CMAKE_CUDA_USE_RESPONSE_FILE_FOR_INCLUDES OFF)
set(CMAKE_CUDA_USE_RESPONSE_FILE_FOR_LIBRARIES OFF)
set(CMAKE_CUDA_USE_RESPONSE_FILE_FOR_OBJECTS OFF)

file(GLOB_RECURSE SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cu
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
)

add_library(konch_nn SHARED ${SRC})
add_library(konch::nn ALIAS konch_nn)

set_target_properties(konch_nn PROPERTIES
    CUDA_RUNTIME_LIBRARY Shared
    CUDA_SEPARABLE_COMPILATION ON
)

set_target_minimum_cuda_arch(konch_nn 75)

target_compile_features(konch_nn PRIVATE
    cxx_std_20
    cuda_std_20
)

target_compile_options(konch_nn PRIVATE
    -Wall -O3
    $<$<COMPILE_LANGUAGE:CUDA>:
        --expt-relaxed-constexpr
        -Wno-deprecated-gpu-targets>
)

target_include_directories(konch_nn PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include/
)

target_link_libraries(konch_nn PRIVATE
    CUDA::cudart
    konch::core
)
