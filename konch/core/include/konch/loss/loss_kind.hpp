#ifndef _KONCH_LOSS_KIND_
#define _KONCH_LOSS_KIND_

#include "../module/module/module_kind.hpp"
#include <concepts>  // IWYU pragma: keep

namespace konch {
template <class T>
concept LossKind = ModuleKind<T> and requires { typename T::loss_manual_feature; };
// concept LossKind = requires { typename T::loss_manual_feature; };
}  // namespace konch

#endif  // _KONCH_LOSS_KIND_
