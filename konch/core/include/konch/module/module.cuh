#ifndef _KONCH_MODULE_
#define _KONCH_MODULE_

#include "konch/module/module_joint.cuh"
#include "konch/module/module_state.cuh"

namespace konch {

template <class ModuleT,
    ModuleInputKind InputT,
    ModuleOutputKind OutputT,
    ModuleStateKind StateT>
struct Module {
  using input_t = InputT;
  using output_t = OutputT;
  using state_t = StateT;

  InputT input;
  StateT state;
  OutputT output;

  void eval() {
    static_assert(std::is_base_of_v<Module<ModuleT, InputT, OutputT, StateT>, ModuleT>,
        "ModuleT must inherit from Module<ModuleT, InputT, OutputT, StateT> (CRTP "
        "requirement)");

    static_assert(not std::is_same_v<Module, ModuleT>,
        "Direct eval() call to base Module class detected.\n"
        "This is a CRTP base class - you must:\n"
        " 1. Inherit from this class using CRTP pattern\n"
        " 2. Implement eval() in your derived class\n"
        " 3. Call through derived instance only");
  }

  template <TensorKind... TensorT>
  const OutputT& operator()(const TensorT&... tensors) {
    input.set(tensors...);
    static_cast<ModuleT>(this)->eval();
    return output;
  }

  const OutputT& operator()(const InputT& other_input) {
    input.set(other_input);
    static_cast<ModuleT>(this)->eval();
    return output;
  }
};

}  // namespace konch

#endif  // _KONCH_MODULE_
