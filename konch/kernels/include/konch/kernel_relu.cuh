#ifndef _KONCH_KERNEL_RELU_
#define _KONCH_KERNEL_RELU_

#include <konch/core.cuh>

struct ReLUConfig {
  dim3 block;
  dim3 grid;
  std::size_t shmem = 0;
  cudaStream_t stream = 0;
};

namespace konch {

__kernel(ReLUConfig) void relu(AutoAccessor y, const AutoAccessor x) {
  index_t i = threadIdx.x + blockIdx.x * blockDim.x;
  typename decltype(y)::atom_t zero = 0;
  if (i < x.view.numel) y[i] = x[i] > zero ? x[i] : zero;
}

KONCH_REGISTER_KERNEL_LAUNCHER(KernelReLULauncher, relu, ReLUConfig);

}  // namespace konch

#endif  // _KONCH_KERNEL_RELU_
