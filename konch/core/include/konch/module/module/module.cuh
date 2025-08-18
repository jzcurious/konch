#ifndef _KONCH_MODULE_MODULE_
#define _KONCH_MODULE_MODULE_

#include "../context/context.cuh"  // IWYU pragma: export
#include "../parameter/parameter.cuh"  // IWYU pragma: export
#include "../state/state.cuh"  // IWYU pragma: export
#include "./module_kind.hpp"  // IWYU pragma: export

#include <nvtx3/nvtx3.hpp>

namespace konch {

template <TensorKind... TensorT>
using I = ModuleInput<TensorT...>;

template <TensorKind... TensorT>
using O = ModuleOutput<TensorT...>;

template <TensorKind... TensorT>
using IO = ModuleInput<TensorT...>;

template <ModuleInputKind InputT, ModuleOutputKind OutputT, class DerivedT = void>
struct ModuleBase {
  struct module_manual_feature {};

  using base_t = ModuleBase<InputT, OutputT, DerivedT>;
  using input_t = InputT;
  using output_t = OutputT;

  static constexpr const bool crtp = ModuleKind<DerivedT>;

  Context<InputT> input_ctx;
  Context<OutputT> output_ctx;

  auto* derived() {
    return static_cast<DerivedT*>(this);
  }

  const auto* derived() const {
    return static_cast<const DerivedT*>(this);
  }

  output_t forward(const input_t& args) {
    if constexpr (crtp)
      return derived()->forward(args);
    else
      return {};
  }

  input_t backward(const output_t& args) {
    if constexpr (crtp)
      return derived()->backward(args);
    else
      return {};
  }

  const input_t& keep_input(const input_t& args) {
    return input_ctx(InputT(args));
  }

  const output_t& keep_output(const output_t& args) {
    return output_ctx(OutputT(args));
  }

  auto params() {
    if constexpr (crtp)
      return derived()->params();
    else
      return Parameters<>{};
  }

  static constexpr std::string repr() {
    std::string result = crtp ? utils::type_of<DerivedT>() : "Module";

    if constexpr (std::is_same_v<typename InputT::complement_t, OutputT>)
      result += "<I" + utils::repr_types_pack<OutputT>() + ">";
    else
      result += "<" + utils::repr_types_pack<InputT, OutputT>() + ">";

    return result;
  }
};

template <ModuleInputKind InputT, class OutputT = void, class DerivedT = void>
struct Module : ModuleBase<InputT,
                    std::conditional_t<std::is_void_v<OutputT>,
                        typename InputT::complement_t,
                        OutputT>,
                    DerivedT> {};

}  // namespace konch

#endif  // _KONCH_MODULE_MODULE_
