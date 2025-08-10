#ifndef _KONCH_INITIALIZER_
#define _KONCH_INITIALIZER_

#include "../../tensor/tensor_kind.hpp"
#include "./initializer_kind.hpp"  // IWYU pragma: export

namespace konch {

template <TensorKind TensorT>
struct Initializer {
  struct initializer_manual_feature {};

  TensorT& operator()(TensorT& tensor) {
    return tensor;
  }
};

}  // namespace konch

#endif  // _KONCH_INITIALIZER_
