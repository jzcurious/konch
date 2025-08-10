#ifndef _KONCH_STATE_KIND_
#define _KONCH_STATE_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept StateKind = requires { typename T::state_manual_feature; };

}  // namespace konch

#endif  // _KONCH_STATE_KIND_
