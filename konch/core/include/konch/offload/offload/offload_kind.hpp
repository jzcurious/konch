#ifndef _KONCH_OFFLOAD_KIND_
#define _KONCH_OFFLOAD_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept OffloadKind = requires { typename T::offload_manual_feature; };

}  // namespace konch

#endif  // _KONCH_OFFLOAD_KIND_
