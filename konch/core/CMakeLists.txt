cmake_minimum_required(VERSION 3.31)
project(konch_core LANGUAGES CXX CUDA)

include(../../cmake/cuda_arch.cmake)
set_minimum_cuda_arch(75)

include(../../cmake/cuda_compile_commands.cmake)
include(../../cmake/nvtx.cmake)
include(../../cmake/nvbench.cmake)

find_package(CUDAToolkit REQUIRED)

add_library(konch_core INTERFACE ${SRC})
add_library(konch::core ALIAS konch_core)

set_target_minimum_cuda_arch(konch_core 75)

target_include_directories(konch_core INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}/include/
)

target_compile_features(konch_core INTERFACE
    cxx_std_20
    cuda_std_20
)

target_compile_options(konch_core INTERFACE
    -Wall -O3
    $<$<COMPILE_LANGUAGE:CUDA>:
        --expt-relaxed-constexpr
        -Wno-deprecated-gpu-targets>
)

target_link_libraries(konch_core INTERFACE
    CUDA::cudart
    nvtx3-cpp
    nvbench::main
)
