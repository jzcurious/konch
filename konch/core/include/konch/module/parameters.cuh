#ifndef _KONCH_PARAMETERS_
#define _KONCH_PARAMETERS_

#include "../tensor/tensor_kind.hpp"
#include "./parameters_kind.cuh"  // IWYU pragma: export

#include <tuple>

namespace konch {

template <TensorKind... TensorT>
struct Parameters {
  struct parameters_manual_feature {};

  using values_t = std::tuple<TensorT&...>;

  std::tuple<TensorT&...> values;

  Parameters(TensorT&... tensors)
      : values(tensors...) {}
};

}  // namespace konch

#endif  // _KONCH_PARAMETERS_
