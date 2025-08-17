#ifndef _KONCH_VIEW_KIND_
#define _KONCH_VIEW_KIND_

#include <concepts>  // IWYU pragma: keep

#include <string>

namespace konch {

template <class T>
concept ViewKind = requires { typename T::view_manual_feature; } and requires(T x) {
  { x.repr() } -> std::same_as<std::string>;
};

}  // namespace konch

#endif  // _KONCH_VIEW_KIND_
