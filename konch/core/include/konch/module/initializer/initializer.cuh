#ifndef _KONCH_INITIALIZER_
#define _KONCH_INITIALIZER_

#include "../parameter/parameter_kind.hpp"
#include "./initializer_kind.hpp"  // IWYU pragma: export

namespace konch {

template <ParameterKind ParameterT>
struct Initializer {
  struct initializer_manual_feature {};

  void operator()(ParameterT& param) {}
};

}  // namespace konch

#endif  // _KONCH_INITIALIZER_
