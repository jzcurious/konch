#ifndef _KONCH_GRADIENT_
#define _KONCH_GRADIENT_

#include "../module/module.cuh"

namespace konch {

template <TrainableModule ModuleT>
struct Gradient {};

template <TrainableAtomicModuleKind ModuleT>
struct Gradient<ModuleT> {
  struct gradient_manual_feature {};

  using values_t = decltype(ModuleT{}.params().values);

  values_t values;

  Gradient(ModuleT& module)
      : values(module.params().values) {}
};

template <TrainableChainModuleKind ModuleT>
struct Gradient<ModuleT> {
  struct gradient_manual_feature {};

  // clang-format off

  template <class Tuple, std::size_t... Is>
  static auto get_gradient_types(std::index_sequence<Is...>) {
    return std::tuple<
        typename Gradient<
          std::remove_reference_t<
            std::get<Is>(Tuple)
          >
        >::values_t...
    >{};
  }

  // clang-format on

  using values_t = decltype(get_gradient_types<typename ModuleT::submodules_t>(
      std::make_index_sequence<std::tuple_size_v<typename ModuleT::submodules_t>>{}));

  values_t values;
};

}  // namespace konch

#endif  // _KONCH_GRADIENT_
