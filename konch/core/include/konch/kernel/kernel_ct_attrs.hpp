#ifndef _KERNEL_CT_ATTRS_
#define _KERNEL_CT_ATTRS_

#include "konch/kernel/kernel_ct_attrs_kind.hpp"  // IWYU pragma: export

#include <cuda_runtime.h>

namespace konch {

struct KernelAttrsCT {
  struct kernel_attrs_ct_manual_ferature {};
};

}  // namespace konch

#endif  // _KERNEL_CT_ATTRS_
