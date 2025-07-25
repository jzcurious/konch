cmake_minimum_required(VERSION 3.24)
project(konch_samples LANGUAGES CUDA)

include(../cmake/cuda_compile_commands.cmake)
include(../cmake/cuda_arch.cmake)

file(GLOB_RECURSE SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/*.cu
)

add_executable(konch_samples ${SRC})

set_target_minimum_cuda_arch(konch_samples 75)

target_compile_features(konch_samples PRIVATE
    cuda_std_20
    cxx_std_20
)

target_compile_options(konch_samples PRIVATE
    -Wall -O3
    $<$<COMPILE_LANGUAGE:CUDA>:
        --expt-relaxed-constexpr
        -Wno-deprecated-gpu-targets>
)

target_link_libraries(konch_samples PRIVATE
    konch::kernels
)
