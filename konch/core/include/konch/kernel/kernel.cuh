#ifndef _KONCH_KERNEL_
#define _KONCH_KERNEL_

#include "../accessor/accessor_kind.hpp"  // IWYU pragma: keep
#include "../index/index_type.hpp"  // IWYU pragma: export
#include "./kernel_config.hpp"  // IWYU pragma: keep

#define __kernel__                                                                       \
  template <konch::KernelConfigKind auto config>                                         \
  __global__

#define AutoAccessor AccessorKind auto

#endif  // _KONCH_KERNEL_
