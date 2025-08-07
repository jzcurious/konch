#ifndef _KONCH_PARAMETER_CUH_
#define _KONCH_PARAMETER_CUH_

#include "../tensor/tensor.cuh"

namespace konch {

template <AtomKind AtomT, index_t... sizes>
struct Parameter {
  using tensor_t = Tensor<AtomT, sizes...>;
  using accessor_t = Tensor<AtomT, sizes...>::accessor_t;

  Tensor<AtomT, sizes...> value;
  Tensor<AtomT, sizes...> grad;

  operator Tensor<AtomT, sizes...>&() {
    return value;
  }

  operator const Tensor<AtomT, sizes...>&() const {
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

#endif  // _KONCH_PARAMETER_CUH_
