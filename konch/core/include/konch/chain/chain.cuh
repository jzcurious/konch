#ifndef _KONCH_CHAIN_CHAIN_
#define _KONCH_CHAIN_CHAIN_

#include "../module/module.cuh"

#include <tuple>

namespace konch::internal {

template <ModuleKind... ModuleT>
struct first_type {
  using type = std::tuple_element_t<0, std::tuple<ModuleT...>>;
};

template <ModuleKind... ModuleT>
using first_type_t = typename first_type<ModuleT...>::type;

template <ModuleKind... ModuleT>
struct last_type {
  using type = std::tuple_element_t<sizeof...(ModuleT) - 1, std::tuple<ModuleT...>>;
};

template <ModuleKind... ModuleT>
using last_type_t = typename last_type<ModuleT...>::type;

}  // namespace konch::internal

namespace konch {

template <ModuleKind... ModuleT>
struct Chain : Module<typename internal::first_type_t<ModuleT...>::input_t,
                   typename internal::last_type_t<ModuleT...>::output_t> {

 public:
  struct chain_module_manual_feature {};

  using submodules_t = std::tuple<ModuleT...>;

  std::tuple<ModuleT...> modules;

  const auto& operator()(const Chain::input_t& args) {
    this->input = args;
    return this->output = compose_modules(std::make_index_sequence<sizeof...(ModuleT)>());
  }

 private:
  template <size_t... Index>
  const auto& compose_modules(std::index_sequence<Index...>) {
    (
        [&]() {
          if constexpr (Index > 0) {
            std::get<Index>(modules)(std::get<Index - 1>(modules).output);
          } else {
            std::get<0>(modules)(this->input);
          }
        }(),
        ...);

    return std::get<sizeof...(ModuleT) - 1>(modules).output;
  }
};

}  // namespace konch

#endif  // _KONCH_CHAIN_CHAIN_
