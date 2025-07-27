#ifndef _KONCH_KERNEL_
#define _KONCH_KERNEL_

#include "../accessor/accessor_kind.hpp"  // IWYU pragma: keep
#include "../index/index_type.hpp"  // IWYU pragma: export
#include "./kernel_config_kind.hpp"  // IWYU pragma: keep

#define __kernel__                                                                       \
  template <KernelConfigKind auto config>                                                \
  __global__

#define __kernel(config_type)                                                            \
  template <config_type config>                                                          \
  __global__

namespace konch {

template <class T, class... ArgT>
concept KernelKind = requires(T x, ArgT... args) {
  { x<<<1, 1, 0, 0>>>(args...) } -> std::same_as<void>;
};

}  // namespace konch

#define AutoAccessor AccessorKind auto

#endif  // _KONCH_KERNEL_
