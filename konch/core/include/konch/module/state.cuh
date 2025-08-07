#ifndef _KONCH_STATE_
#define _KONCH_STATE_

#include "../tensor/tensor.cuh"
#include "./state_kind.hpp"  // IWYU pragma: export

namespace konch {

template <AtomKind AtomT, index_t... sizes>
struct State {
  struct state_manual_feature {};

  using tensor_t = Tensor<AtomT, sizes...>;
  using accessor_t = Tensor<AtomT, sizes...>::accessor_t;

  Tensor<AtomT, sizes...> value;

  operator Tensor<AtomT, sizes...>() {
    return value;
  }

  operator const Tensor<AtomT, sizes...>() const {
    return value;
  }

  operator typename Tensor<AtomT, sizes...>::accessor_t &() {
    return value.accessor();
  }

  operator const typename Tensor<AtomT, sizes...>::accessor_t &() const {
    return value.accessor();
  }
};

}  // namespace konch

#endif  // _KONCH_STATE_
