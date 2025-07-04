#ifndef _KONCH_KERNEL_LAUNCHER_KIND_
#define _KONCH_KERNEL_LAUNCHER_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept KernelLauncherKind = requires { typename T::kernel_launcher_manual_ferature; };

}  // namespace konch

#endif  // _KONCH_KERNEL_LAUNCHER_KIND_
