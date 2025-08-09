#ifndef _KONCH_TRAIN_OPTIMIZER_
#define _KONCH_TRAIN_OPTIMIZER_

#include "../module/module_kind.hpp"

namespace konch {

template <TrainableModuleKind ModuleT>
struct Optimizer {
 private:
  ModuleT& module_;

 public:
  Optimizer(ModuleT& module)
      : module_(module) {}
};

}  // namespace konch

#endif  // _KONCH_TRAIN_OPTIMIZER_
