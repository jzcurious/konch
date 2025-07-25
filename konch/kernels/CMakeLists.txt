cmake_minimum_required(VERSION 3.24)
project(konch_kernels LANGUAGES CUDA)

include(../../cmake/cuda_arch.cmake)
include(../../cmake/cuda_compile_commands.cmake)

add_library(konch_kernels INTERFACE ${SRC})
add_library(konch::kernels ALIAS konch_kernels)

set_target_minimum_cuda_arch(konch_kernels 75)

target_compile_features(konch_kernels INTERFACE
    cxx_std_20
    cuda_std_20
)

target_compile_options(konch_kernels INTERFACE
    -Wall -O3
    $<$<COMPILE_LANGUAGE:CUDA>:
        --expt-relaxed-constexpr
        -Wno-deprecated-gpu-targets>
)

target_include_directories(konch_kernels INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}/include/
)

target_link_libraries(konch_kernels INTERFACE
    konch::core
)
