#ifndef _KONCH_LOSS_
#define _KONCH_LOSS_

#include "../module/module/module.cuh"
#include "./loss_kind.hpp"  // IWYU pragma: export

namespace konch {

template <ModuleKind ModuleT, ModuleOutputKind OutputT>
struct Loss : Module<typename ModuleT::output_t::complement_t, OutputT> {
  struct loss_manual_feature {};
};

}  // namespace konch

#endif  // _KONCH_LOSS_
