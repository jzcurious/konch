#ifndef _KONCH_OFFLOAD_CONFIG_KIND_
#define _KONCH_OFFLOAD_CONFIG_KIND_

#include <concepts>  // IWYU pragma: keep
#include <cuda_runtime.h>

namespace konch {

template <class T>
concept OffloadConfigKind = requires(T x) {
  { x.grid } -> std::convertible_to<dim3>;
  { x.block } -> std::convertible_to<dim3>;
  { x.shmem } -> std::convertible_to<std::size_t>;
  // { x.stream } -> std::convertible_to<cudaStream_t>;
};

}  // namespace konch

#endif  // _KONCH_OFFLOAD_CONFIG_KIND_
