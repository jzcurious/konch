#ifndef _KONCH_OPTIMIZER_KIND_
#define _KONCH_OPTIMIZER_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept OptimizerKind = requires { typename T::optimizer_manual_feature; };

}  // namespace konch

#endif  // _KONCH_OPTIMIZER_KIND_
