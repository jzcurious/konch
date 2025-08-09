#ifndef _MLP_OFFLOAD_REDUCE_COLUMNS_
#define _MLP_OFFLOAD_REDUCE_COLUMNS_

#include <konch/core.cuh>

struct ReduceColumnsConfig {
  dim3 block;
  dim3 grid;
  std::size_t shmem = 0;
  cudaStream_t stream = 0;
};

namespace konch {

__kernel(ReduceColumnsConfig) void reduce_columns(AutoAccessor y, const AutoAccessor x) {
  index_t j = blockDim.x * blockIdx.x + threadIdx.x;

  typename decltype(y)::atom_t y_acc = 0;

  if (j < x.view.size(1)) {
    for (index_t i = 0; i < x.view.size(0); ++i) y_acc += x(i, j);
    y[j] = y_acc;
  }
}

KONCH_REGISTER_OFFLOAD(ReduceColumnsOffload, reduce_columns, ReduceColumnsConfig);

}  // namespace konch

#endif  // _MLP_OFFLOAD_REDUCE_COLUMNS_
