#ifndef _KONCH_KERNEL_ELEMENT_WISE_
#define _KONCH_KERNEL_ELEMENT_WISE_

#include <konch/core.cuh>

struct ElementWiseConfig {
  dim3 block;
  dim3 grid;
  std::size_t shmem = 0;
  cudaStream_t stream = 0;
};

#endif  // _KONCH_KERNEL_ELEMENT_WISE_
