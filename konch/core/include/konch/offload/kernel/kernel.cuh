#ifndef _KONCH_KERNEL_
#define _KONCH_KERNEL_

#include "../../accessor/accessor_kind.hpp"  // IWYU pragma: keep
#include "../../index/index_type.hpp"  // IWYU pragma: export
#include "../config/offload_config_kind.hpp"  // IWYU pragma: keep
#include "./kernel_kind.cuh"  // IWYU pragma: export

#define __kernel__                                                                       \
  template <OffloadConfigKind auto config>                                               \
  __global__

#define __kernel(config_type)                                                            \
  template <config_type config>                                                          \
  __global__

#define AutoAccessor AccessorKind auto

#endif  // _KONCH_KERNEL_
