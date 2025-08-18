#ifndef _KONCH_CHAIN_CHAIN_KIND_
#define _KONCH_CHAIN_CHAIN_KIND_

#include "../module/module/module_kind.hpp"
#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept ChainKind = ModuleKind<T> and requires { typename T::chain_manual_feature; };

}  // namespace konch

#endif  // _KONCH_CHAIN_CHAIN_KIND_
