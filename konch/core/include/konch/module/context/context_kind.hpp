#ifndef _KONCH_CONTEXT_KIND_
#define _KONCH_CONTEXT_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept ContextKind = requires {
  typename T::context_manual_feature;
  typename T::joint_t;
};

}  // namespace konch

#endif  // _KONCH_CONTEXT_KIND_
