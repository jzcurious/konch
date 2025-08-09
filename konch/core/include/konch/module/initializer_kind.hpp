#ifndef _KONCH_INITIALIZER_KIND_
#define _KONCH_INITIALIZER_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept InitializerKind
    = requires { typename T::initializer_manual_feature; } and requires(T x) {
        { x() } -> TensorKind;
      };

}  // namespace konch

#endif  // _KONCH_INITIALIZER_KIND_
