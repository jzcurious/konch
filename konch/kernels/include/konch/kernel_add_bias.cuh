#ifndef _KONCH_KERNEL_ADD_BIAS_
#define _KONCH_KERNEL_ADD_BIAS_

#include <konch/core.cuh>

namespace konch {

__kernel__ void add_bias(AutoAccessor y, const AutoAccessor x, const AutoAccessor b) {
  index_t i = blockDim.y * blockIdx.y + threadIdx.y;
  index_t j = blockDim.x * blockIdx.x + threadIdx.x;

  if (i < x.size(0) and j < x.size(1)) y(i, j) = x(i, j) + b[j];
}

KONCH_REGISTER_KERNEL_LAUNCHER(KernelAddBiasLauncher, add_bias);

}  // namespace konch

#endif  // _KONCH_KERNEL_ADD_BIAS_
