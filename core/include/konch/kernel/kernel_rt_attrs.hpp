#ifndef _KERNEL_RT_ATTRS_
#define _KERNEL_RT_ATTRS_

#include "konch/kernel/kernel_rt_attrs_kind.hpp"  // IWYU pragma: export

#include <cuda_runtime.h>

namespace konch {

struct KernelAttrsRT {
  cudaStream_t stream;
  dim3 block;
  dim3 grid;
  std::size_t shmem;

  struct kernel_attrs_rt_manual_ferature {};
};

}  // namespace konch

#endif  // _KERNEL_RT_ATTRS_
