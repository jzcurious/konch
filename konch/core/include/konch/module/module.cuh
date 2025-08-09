#ifndef _KONCH_MODULE_MODULE_
#define _KONCH_MODULE_MODULE_

#include "./context.cuh"  // IWYU pragma: export
#include "./module_kind.hpp"  // IWYU pragma: export
#include "./parameter.cuh"  // IWYU pragma: export
#include "./state.cuh"  // IWYU pragma: export

namespace konch {

template <ModuleInputKind InputT, ModuleOutputKind OutputT>
struct ModuleBase {
  struct module_manual_feature {};

  using input_t = InputT;
  using output_t = OutputT;

  Context<InputT> input_ctx;
  Context<OutputT> output_ctx;

  const input_t& keep_input(const input_t& args) {
    return input_ctx(InputT(args));
  }

  const output_t& keep_output(const output_t& args) {
    return output_ctx(OutputT(args));
  }

  Parameters<> parameters() {
    return {};
  }
};

template <TensorKind... TensorT>
using I = ModuleInput<TensorT...>;

template <TensorKind... TensorT>
using O = ModuleOutput<TensorT...>;

template <TensorKind... TensorT>
using IO = ModuleInput<TensorT...>;

template <ModuleInputKind InputT, class OutputT = void>
struct Module : ModuleBase<InputT,
                    std::conditional_t<std::is_void_v<OutputT>,
                        typename InputT::compliment_t,
                        OutputT>> {};

}  // namespace konch

#endif  // _KONCH_MODULE_MODULE_
