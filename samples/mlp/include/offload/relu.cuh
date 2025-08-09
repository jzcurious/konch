#ifndef _MLP_OFFLOAD__RELU_
#define _MLP_OFFLOAD__RELU_

#include <konch/core.cuh>

struct ReLUConfig {
  dim3 block;
  dim3 grid;
  std::size_t shmem = 0;
  cudaStream_t stream = 0;
};

namespace konch {

__kernel(ReLUConfig) void relu(AutoAccessor y, const AutoAccessor x) {
  index_t j = threadIdx.x + blockIdx.x * blockDim.x;
  index_t i = threadIdx.y + blockIdx.y * blockDim.y;

  typename decltype(y)::atom_t zero = 0;

  if (j < x.view.size(1) and i < x.view.size(0))
    y(i, j) = x(i, j) > zero ? x(i, j) : zero;
}

KONCH_REGISTER_OFFLOAD(ReLUOffload, relu, ReLUConfig);

}  // namespace konch

#endif  // _MLP_OFFLOAD__RELU_
