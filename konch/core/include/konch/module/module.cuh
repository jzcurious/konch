#ifndef _KONCH_MODULE_
#define _KONCH_MODULE_

#include "konch/module/module_joint.cuh"

namespace konch {

template <class ModuleT, ModuleInputKind InputT, ModuleOutputKind OutputT>
struct Module {
  using input_t = InputT;
  using output_t = OutputT;
};

}  // namespace konch

#endif  // _KONCH_MODULE_
