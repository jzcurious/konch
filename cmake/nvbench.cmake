include(FetchContent)

set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS TRUE)

FetchContent_Declare(
  nvbench
  GIT_REPOSITORY https://github.com/NVIDIA/nvbench.git
  GIT_TAG main
  GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(nvbench)

set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS FALSE)
