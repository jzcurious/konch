#ifndef _KONCH_TENSOR_KIND_
#define _KONCH_TENSOR_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept TensorKind = requires { typename T::tensor_manual_feature; };

}  // namespace konch

#endif  // _KONCH_TENSOR_KIND_
