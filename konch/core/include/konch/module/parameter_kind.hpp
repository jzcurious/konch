#ifndef _KONCH_PARAMETER_KIND_
#define _KONCH_PARAMETER_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept ParameterKind = requires { typename T::parameter_manual_feature; };

template <class T>
concept ParametersTupleKind = requires { typename T::parameters_manual_feature; };

}  // namespace konch

#endif  // _KONCH_PARAMETER_KIND_
