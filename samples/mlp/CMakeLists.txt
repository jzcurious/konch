cmake_minimum_required(VERSION 3.31)
project(konch_sample_mlp LANGUAGES CXX CUDA)

include(../../cmake/cuda_compile_commands.cmake)
include(../../cmake/cuda_arch.cmake)

file(GLOB_RECURSE SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/*.cu
)

add_executable(konch_sample_mlp ${SRC})

target_include_directories(konch_sample_mlp PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include/
)

set_target_minimum_cuda_arch(konch_sample_mlp 75)

target_compile_features(konch_sample_mlp PRIVATE
    cuda_std_20
    cxx_std_20
)

target_compile_options(konch_sample_mlp PRIVATE
    -Wall -O3
    $<$<COMPILE_LANGUAGE:CUDA>:
        --expt-relaxed-constexpr
        -Wno-deprecated-gpu-targets>
)

target_link_libraries(konch_sample_mlp PRIVATE
    konch::core
)
