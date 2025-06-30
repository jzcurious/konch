#ifndef _KONCH_KERNEL_RT_ATTRS_KIND_
#define _KONCH_KERNEL_RT_ATTRS_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept KernelAttrsRTKind = requires { typename T::kernel_attrs_rt_manual_ferature; };

}  // namespace konch

#endif  // _KONCH_KERNEL_RT_ATTRS_KIND_
