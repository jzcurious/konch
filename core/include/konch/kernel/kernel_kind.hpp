#ifndef _KONCH_KERNEL_KIND_
#define _KONCH_KERNEL_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept KernelKind = requires { typename T::kernel_manual_feature; };

}  // namespace konch

#endif  // _KONCH_KERNEL_KIND_
