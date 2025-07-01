#ifndef _KONCH_VIEW_KIND_
#define _KONCH_VIEW_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept ViewKind = requires { typename T::view_manual_feature; };

template <ViewKind... ViewT>
struct ViewsTypeList {};

}  // namespace konch

#endif  // _KONCH_VIEW_KIND_
