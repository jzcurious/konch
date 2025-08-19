cmake_minimum_required(VERSION 3.31)
project(konch_tests LANGUAGES CXX)

include(../cmake/gtest.cmake)
include(../cmake/eigen.cmake)

find_package(CUDAToolkit REQUIRED)

file(GLOB_RECURSE SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
)

add_executable(konch_tests ${SRC})

target_include_directories(konch_tests PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include/
)

target_compile_features(konch_tests PRIVATE
    cxx_std_20
)

target_compile_options(konch_tests PRIVATE
    -Wall -O3
)

target_link_libraries(konch_tests PRIVATE
    konch::core
    CUDA::cudart
    GTest::gtest_main
    Eigen3::Eigen
)

enable_testing()
gtest_discover_tests(konch_tests)
