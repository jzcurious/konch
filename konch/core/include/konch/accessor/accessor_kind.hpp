#ifndef _KONCH_ACCESSOR_KIND_
#define _KONCH_ACCESSOR_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept AccessorKind = requires {
  typename T::accessor_manual_feature;
  typename T::atom_t;
};

}  // namespace konch

#endif  // _KONCH_ACCESSOR_KIND_
