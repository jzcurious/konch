#ifndef _KONCH_MODULE_STATE_
#define _KONCH_MODULE_STATE_

#include "konch/module/module_state_kind.hpp"  // IWYU pragma: export
#include "konch/tensor/tensor.cuh"

#include <tuple>

namespace konch {

template <TensorKind... TensorT>
struct ModuleState {
  struct module_state_manual_feature {};

  using view_t = ViewsTypeList<typename TensorT::view_t...>;
  using value_t = std::tuple<std::reference_wrapper<TensorT>...>;

  value_t value;

  ModuleState()
      : value(TensorT{}...) {}
};

}  // namespace konch

#endif  // _KONCH_MODULE_STATE_
