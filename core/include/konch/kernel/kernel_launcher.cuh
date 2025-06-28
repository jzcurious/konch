#ifndef _KONCH_KERNEL_LAUNCHER_
#define _KONCH_KERNEL_LAUNCHER_

#include "konch/accessor/accessor_kind.hpp"
#include "konch/kernel/kernel_ct_attrs.hpp"  // IWYU pragma: keep
#include "konch/kernel/kernel_rt_attrs.hpp"

namespace konch {

template <class KernelFunctorT>
struct KernelLauncher {
  struct kernel_manual_feature {};

  KernelAttrsRT rt_attrs;

  template <AccessorKind ResultAccessorT, AccessorKind... ArgAccessorT>
  void operator()(ResultAccessorT& result, const ArgAccessorT&... args) const {
    KernelFunctorT::
        kernel<<<rt_attrs.grid, rt_attrs.block, rt_attrs.shmem, rt_attrs.stream>>>(
            result, args...);
  }
};

}  // namespace konch

#define __kernel__                                                                       \
  template <konch::AccessorKind AccessorT,                                               \
      konch::KernelAttrsCTKind KernelAttrsCTT,                                           \
      KernelAttrsCTT ct_attrs>                                                           \
  __device__

#define REGISTER_KERNEL(functor_name, kernel_name)                                       \
  template <konch::AccessorKind AccessorT,                                               \
      konch::KernelAttrsCTKind KernelAttrsCTT,                                           \
      KernelAttrsCTT ct_attrs>                                                           \
  struct functor_name                                                                    \
      : konch::KernelLauncher<functor_name<AccessorT, KernelAttrsCTT, ct_attrs>> {       \
    template <konch ::AccessorKind ResultAccessorT,                                      \
        konch ::AccessorKind... ArgAccessorT>                                            \
      requires std::is_same_v<AccessorT, ResultAccessorT>                                \
               and (std::is_same_v<AccessorT, ArgAccessorT> and ...)                     \
    static __global__ void kernel(ResultAccessorT result, const ArgAccessorT... args) {  \
      kernel_name<AccessorT, KernelAttrsCTT, ct_attrs>(result, args...);                 \
    }                                                                                    \
  }

#endif  // _KONCH_KERNEL_LAUNCHER_
