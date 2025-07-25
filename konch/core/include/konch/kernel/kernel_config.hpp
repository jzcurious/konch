#ifndef _KERNEL_CONFIG_
#define _KERNEL_CONFIG_

#include "./kernel_config_kind.hpp"  // IWYU pragma: export

#include <cuda_runtime.h>

namespace konch {

struct KernelConfig {
  dim3 grid;
  dim3 block;
  std::size_t shmem = 0;
  // cudaStream_t stream;
};

}  // namespace konch

#endif  // _KERNEL_CONFIG_
