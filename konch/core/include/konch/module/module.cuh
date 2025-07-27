#ifndef _KONCH_MODULE_MODULE_
#define _KONCH_MODULE_MODULE_

#include "./module_kind.hpp"  // IWYU pragma: export

namespace konch {

template <ModuleInputKind InputT, ModuleOutputKind OutputT>
class Module {
 public:
  using input_t = InputT;
  using output_t = OutputT;
};

}  // namespace konch

#define KONCH_REGISTER_MODULE(module_type)                                               \
  static_assert(ModuleKind<module_type>, "Type must satisfy ModuleKind");

#define KONCH_REGISTER_INFERENCE_MODULE(module_type)                                     \
  static_assert(                                                                         \
      InferenceModuleKind<module_type>, "Type must satisfy InferenceModuleKind");

#endif  // _KONCH_MODULE_MODULE_
