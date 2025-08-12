#ifndef _KONCH_TRAIN_OPTIMIZER_
#define _KONCH_TRAIN_OPTIMIZER_

#include "../module/parameter/parameter_kind.hpp"
#include "./optimizer_kind.hpp"  // IWYU pragma: export

namespace konch {

template <ParameterKind ParameterT>
struct Optimizer {
  struct optimizer_manual_feature {};

  void operator()(ParameterT& param) {}
};

}  // namespace konch

#endif  // _KONCH_TRAIN_OPTIMIZER_
