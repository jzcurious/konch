#ifndef _KONCH_ATOM_KIND_
#define _KONCH_ATOM_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept AtomKind = std::is_integral_v<T> or std::is_floating_point_v<T>;

}

#endif  // _KONCH_ATOM_KIND_
