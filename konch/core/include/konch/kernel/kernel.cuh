#ifndef _KONCH_KERNEL_
#define _KONCH_KERNEL_

#include "konch/accessor/accessor_kind.hpp"  // IWYU pragma: keep
#include "konch/index/index_type.hpp"  // IWYU pragma: export
#include "konch/kernel/kernel_ct_attrs.hpp"  // IWYU pragma: keep

#define __kernel__                                                                       \
  template <konch::AccessorKind AccessorT,                                               \
      konch::KernelAttrsCTKind KernelAttrsCTT,                                           \
      KernelAttrsCTT ct_attrs>                                                           \
  __device__

#endif  // _KONCH_KERNEL_
