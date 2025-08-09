#ifndef _KONCH_PARAMETER_
#define _KONCH_PARAMETER_

#include "../tensor/tensor.cuh"
#include "./parameter_kind.hpp"

#include <tuple>

namespace konch {

template <AtomKind AtomT, index_t... sizes>
struct Parameter {
  struct parameter_manual_feature {};

  using tensor_t = Tensor<AtomT, sizes...>;
  using accessor_t = Tensor<AtomT, sizes...>::accessor_t;

  Tensor<AtomT, sizes...> value;
  Tensor<AtomT, sizes...> grad;

  operator typename Tensor<AtomT, sizes...>::accessor_t &() {
    return value.accessor();
  }

  operator const typename Tensor<AtomT, sizes...>::accessor_t &() const {
    return value.accessor();
  }

  // TODO: zero grad, init
};

template <ParameterKind... ParameterT>
struct Parameters : std::tuple<ParameterT&...> {
  struct parameters_manual_feature {};

  using std_tuple_t = std::tuple<ParameterT&...>;

  Parameters(ParameterT&... parameters)
      : std::tuple<ParameterT&...>(parameters...) {}

  template <ParameterKind... _ParameterT>
  Parameters(const std::tuple<_ParameterT&...>& std_tuple)
      : std::tuple<ParameterT&...>(std_tuple) {}

  // TODO: zero grad, init
};

template <ParameterKind... _ParameterT>
Parameters(const std::tuple<_ParameterT&...>& std_tuple) -> Parameters<_ParameterT...>;

template <ParametersTupleKind... ParametersT>
auto cat_parameters(const ParametersT&... parameters) {
  return Parameters(std::tuple_cat(static_cast<ParametersT::std_tuple_t>(parameters)...));
}

}  // namespace konch

#endif  // _KONCH_PARAMETER_
