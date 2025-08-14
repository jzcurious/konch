#ifndef _KONCH_PARAMETER_
#define _KONCH_PARAMETER_

#include "../../optimizer/optimizer_kind.hpp"
#include "../../tensor/tensor.cuh"
#include "../initializer/initializer_kind.hpp"
#include "./parameter_kind.hpp"

#include <tuple>

namespace konch {

struct SkipInit {};

struct SkipOpt {};

template <TensorKind TensorT, class InitializerT = SkipInit, class OptimizerT = SkipOpt>
  requires((InitializerKind<InitializerT> or std::is_same_v<InitializerT, SkipInit>)
           and (OptimizerKind<OptimizerT> or std::is_same_v<OptimizerT, SkipOpt>))
struct Parameter {
  struct parameter_manual_feature {};

 private:
  InitializerT initializer_;
  OptimizerT optimizer_;

 public:
  using tensor_t = TensorT;
  using accessor_t = TensorT::accessor_t;

  TensorT value;
  TensorT grad;

  Parameter()
      : initializer_()
      , optimizer_()
      , value()
      , grad() {
    init();
  }

  operator typename TensorT::accessor_t &() {
    return value.accessor();
  }

  operator const typename TensorT::accessor_t &() const {
    return value.accessor();
  }

  void init() {
    if constexpr (not std::is_same_v<InitializerT, SkipInit>) initializer_(*this);
  }

  void update() {
    if constexpr (not std::is_same_v<OptimizerT, SkipOpt>) optimizer_(*this);
  }
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

  void init() {
    std::apply(
        [](auto&... params) { (params.init(), ...); }, static_cast<std_tuple_t>(*this));
  }

  void update() {
    std::apply(
        [](auto&... params) { (params.update(), ...); }, static_cast<std_tuple_t>(*this));
  }
};

template <ParameterKind... _ParameterT>
Parameters(const std::tuple<_ParameterT&...>& std_tuple) -> Parameters<_ParameterT...>;

template <ParametersKind... ParametersT>
auto cat_params(const ParametersT&... parameters) {
  return Parameters(std::tuple_cat(static_cast<ParametersT::std_tuple_t>(parameters)...));
}

}  // namespace konch

#endif  // _KONCH_PARAMETER_
