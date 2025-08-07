#ifndef _KONCH_GRADIENT_
#define _KONCH_GRADIENT_

#include "../module/module.cuh"

namespace konch {

template <ModuleKind ModuleT>
struct Gradient : Module<typename ModuleT::output_t::compliment_t,
                      typename ModuleT::input_t::compliment_t> {
  struct gradient_manual_feature {};

  ModuleT& module;

  typename ModuleT::parameters_t d_params;

  Gradient(ModuleT& module)
      : module(module) {}
};

}  // namespace konch

#endif  // _KONCH_GRADIENT_
