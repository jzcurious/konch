#ifndef _KONCH_KERNEL_LAUNCHER_
#define _KONCH_KERNEL_LAUNCHER_

#include "konch/kernel/kernel.cuh"  // IWYU pragma: keep
#include "konch/kernel/kernel_rt_attrs.hpp"

namespace konch {

template <class KernelFunctorT>
struct KernelLauncher {  // TODO: derived from Module (?)

  struct kernel_launcher_manual_feature {};

  KernelAttrsRT rt_attrs;

  template <AccessorKind ResultAccessorT, AccessorKind... ArgAccessorT>
  void operator()(ResultAccessorT& result, const ArgAccessorT&... args) const {
    KernelFunctorT::
        kernel<<<rt_attrs.grid, rt_attrs.block, rt_attrs.shmem, rt_attrs.stream>>>(
            result, args...);
  }
};

}  // namespace konch

#define REGISTER_KERNEL_LAUNCHER(launcher_name, kernel_name)                             \
  template <konch::AccessorKind AccessorT,                                               \
      konch::KernelAttrsCTKind KernelAttrsCTT,                                           \
      KernelAttrsCTT ct_attrs>                                                           \
  struct launcher_name                                                                   \
      : konch::KernelLauncher<launcher_name<AccessorT, KernelAttrsCTT, ct_attrs>> {      \
    template <konch ::AccessorKind ResultAccessorT,                                      \
        konch ::AccessorKind... ArgAccessorT>                                            \
      requires std::is_same_v<AccessorT, ResultAccessorT>                                \
               and (std::is_same_v<AccessorT, ArgAccessorT> and ...)                     \
    static __global__ void kernel(ResultAccessorT result, const ArgAccessorT... args) {  \
      static_assert(std::is_invocable_v<decltype(kernel_name<AccessorT>),                \
                        ResultAccessorT,                                                 \
                        ArgAccessorT...>,                                                \
          "Kernel 'kernel_name<AccessorT>' cannot be invoked with the provided "         \
          "arguments. "                                                                  \
          "Check that:\n"                                                                \
          "  1. The kernel is declared as `__kernel__` and matches the expected "        \
          "signature.\n"                                                                 \
          "  2. 'AccessorT' type is compatible with the "                                \
          "kernel's parameter types.\n"                                                  \
          "  3. All accessors satisfy the required 'AccessorKind' constraints.");        \
      kernel_name<AccessorT, KernelAttrsCTT, ct_attrs>(result, args...);                 \
    }                                                                                    \
  }

#endif  // _KONCH_KERNEL_LAUNCHER_
