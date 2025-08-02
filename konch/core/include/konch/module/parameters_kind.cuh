#ifndef _KONCH_PARAMETERS_KIND_
#define _KONCH_PARAMETERS_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch::internal {

template <typename T>
concept TupleRefKind = requires { std::tuple_size<std::remove_reference_t<T>>::value; };

}  // namespace konch::internal

namespace konch {

template <class T>
concept ParametersKind = requires {
  typename T::parameters_manual_feature;
  typename T::values_t;
} and requires(T x) {
  { x.values } -> internal::TupleRefKind;
};

}  // namespace konch

#endif  // _KONCH_PARAMETERS_KIND_
