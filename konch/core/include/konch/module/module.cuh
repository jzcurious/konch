#ifndef _KONCH_MODULE_MODULE_
#define _KONCH_MODULE_MODULE_

#include "./module_kind.hpp"  // IWYU pragma: export

namespace konch {

template <ModuleInputKind InputT, ModuleOutputKind OutputT>
struct Module {
  using input_t = InputT;
  using output_t = OutputT;

  InputT input;
  OutputT output;

  output_t& forward() {
    return output;
  }

  const output_t& forward() const {
    return output;
  }
};

}  // namespace konch

#define KONCH_REGISTER_MODULE(module_type)                                               \
  static_assert(ModuleKind<module_type>, "Type must satisfy ModuleKind.");

#endif  // _KONCH_MODULE_MODULE_
