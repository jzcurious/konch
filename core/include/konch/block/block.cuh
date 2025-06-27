#ifndef _KONCH_BLOCK_
#define _KONCH_BLOCK_

#include "konch/atom/atom_kind.hpp"

#include <cuda_runtime.h>

namespace konch {

template <AtomKind AtomT>
class Block final {
 public:
  const std::size_t size;

 private:
  AtomT* data_;

 public:
  using atom_t = AtomT;

  Block(std::size_t numel)
      : size(numel * sizeof(AtomT))
      , data_(nullptr) {
    cudaMalloc(&data_, size);
  }

  ~Block() {
    if (data_) cudaFree(data_);
  }

  __host__ __device__ AtomT* data() {
    return data_;
  }

  void copy_from_host(const AtomT* host_data) {
    cudaMemcpy(data_, host_data, size, cudaMemcpyHostToDevice);
  }

  void copy_to_host(AtomT* host_data) {
    cudaMemcpy(host_data, data_, size, cudaMemcpyDeviceToHost);
  }
};

}  // namespace konch

#endif  // _KONCH_BLOCK_
