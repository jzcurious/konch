#ifndef _MLP_OFFLOAD_ADD_BIAS_
#define _MLP_OFFLOAD_ADD_BIAS_

#include <konch/core.cuh>

using namespace konch;

struct AddBiasConfig {
  /* This class is intentionally defined outside the 'konch' namespace. This is required
   * for proper cudafe stub generation. */

  dim3 block;
  dim3 grid;
  std::size_t shmem = 0;
  cudaStream_t stream = 0;
};

__kernel(AddBiasConfig) void add_bias(
    AutoAccessor y, const AutoAccessor x, const AutoAccessor b) {

  index_t i = blockDim.y * blockIdx.y + threadIdx.y;
  index_t j = blockDim.x * blockIdx.x + threadIdx.x;

  if (i < x.view.size(0) and j < x.view.size(1)) y(i, j) = x(i, j) + b[j];
}

KONCH_REGISTER_OFFLOAD(AddBiasOffload, add_bias, AddBiasConfig);

#endif  // _MLP_OFFLOAD_ADD_BIAS_
