#ifndef _KONCH_GRADIENT_
#define _KONCH_GRADIENT_

#include "../module/module.cuh"

namespace konch {

template <ModuleKind ModuleT>
struct Gradient {};

template <AtomicModuleKind ModuleT>
struct Gradient<ModuleT> {
  struct gradient_manual_feature {};

  using values_t = ModuleT::parameters_t;

  values_t values;
};

}  // namespace konch

#endif  // _KONCH_GRADIENT_
