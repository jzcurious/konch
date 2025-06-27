cmake_minimum_required(VERSION 3.24)
project(konch_core LANGUAGES CXX CUDA)

include(../cmake/cuda_arch.cmake)

find_package(CUDAToolkit REQUIRED)

set(CMAKE_CUDA_USE_RESPONSE_FILE_FOR_INCLUDES OFF)
set(CMAKE_CUDA_USE_RESPONSE_FILE_FOR_LIBRARIES OFF)
set(CMAKE_CUDA_USE_RESPONSE_FILE_FOR_OBJECTS OFF)

file(GLOB_RECURSE SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cu
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
)

add_library(konch_core SHARED ${SRC})
add_library(konch::core ALIAS konch_core)

set_target_properties(konch_core PROPERTIES
    CUDA_RUNTIME_LIBRARY Shared
    CUDA_SEPARABLE_COMPILATION ON
)

set_target_minimum_cuda_arch(konch_core 75)

target_compile_features(konch_core PRIVATE
    cxx_std_20
    cuda_std_20
)

target_compile_options(konch_core PRIVATE
    -Wall -O3
    $<$<COMPILE_LANGUAGE:CUDA>:
        --expt-relaxed-constexpr
        -Wno-deprecated-gpu-targets>
)

target_include_directories(konch_core PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include/
)

target_link_libraries(konch_core PRIVATE
    CUDA::cudart
)
