include(FetchContent)

FetchContent_Declare(
  nvtx
  GIT_REPOSITORY https://github.com/NVIDIA/NVTX.git
  GIT_TAG v3.3.0
)
FetchContent_MakeAvailable(nvtx)
