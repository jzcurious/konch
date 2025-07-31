#ifndef _KONCH_MODULE_MODULE_
#define _KONCH_MODULE_MODULE_

#include "./module_kind.hpp"  // IWYU pragma: export

namespace konch::internal {

template <ModuleInputKind InputT, ModuleOutputKind OutputT>
struct ModuleBase {
  using input_t = InputT;
  using output_t = OutputT;

  InputT input;
  OutputT output;

  output_t& operator()() {
    return output;
  }
};

}  // namespace konch::internal

namespace konch {

template <TensorKind... TensorT>
using I = ModuleInput<TensorT...>;

template <TensorKind... TensorT>
using O = ModuleOutput<TensorT...>;

template <TensorKind... TensorT>
using IO = ModuleInput<TensorT...>;

template <ModuleInputKind InputT, class OutputT = void>
struct Module : internal::ModuleBase<InputT,
                    std::conditional_t<std::is_void_v<OutputT>,
                        typename InputT::compliment_t,
                        OutputT>> {};

}  // namespace konch

#endif  // _KONCH_MODULE_MODULE_
