#ifndef _KONCH_KERNEL_ADD_BIAS_
#define _KONCH_KERNEL_ADD_BIAS_

#include "konch/kernel/kernel.cuh"
#include "konch/kernel/kernel_launcher.cuh"

namespace konch {

struct kernel_add_row_ct_attrs : KernelAttrsCT {};

__kernel__ void add_bias(AccessorT& y, const AccessorT& x, const AccessorT& b) {
  index_t i = blockDim.y * blockIdx.y + threadIdx.y;
  index_t j = blockDim.x * blockIdx.x + threadIdx.x;

  if (i < x.size(0) and j < x.size(1)) y(i, j) = x(i, j) + b[j];
}

REGISTER_KERNEL_LAUNCHER(KernelAddBiasLauncher, add_bias);

}  // namespace konch

#endif  // _KONCH_KERNEL_ADD_BIAS_
