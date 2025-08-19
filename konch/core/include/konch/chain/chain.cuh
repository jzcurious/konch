#ifndef _KONCH_CHAIN_CHAIN_
#define _KONCH_CHAIN_CHAIN_

#include "../module/module/module.cuh"
#include "./chain_kind.hpp"

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
  requires(sizeof...(ModuleT) > 0)
struct Chain : Module<typename internal::first_type_t<ModuleT...>::input_t,
                   typename internal::last_type_t<ModuleT...>::output_t,
                   Chain<ModuleT...>> {

 public:
  struct chain_manual_feature {};

  static constexpr const size_t len = sizeof...(ModuleT);

  auto params() {
    return collect_params(std::make_index_sequence<len>());  // TODO: refactor it
  }

  Chain::output_t forward(const Chain::input_t& args) {
    return forward_compose(args, std::make_index_sequence<len>());
  }

  Chain::input_t backward(const Chain::output_t& args) {
    return backward_compose(args, std::make_index_sequence<len>());
  }

  static constexpr std::string repr() {
    return _repr();
  }

 private:
  std::tuple<std::conditional_t<ModuleT::crtp, typename ModuleT::base_t, ModuleT>...>
      modules_;

  std::tuple<typename ModuleT::output_t...> module_outputs_;
  std::tuple<typename ModuleT::input_t...> module_d_inputs_;

  template <size_t... Index>
  auto collect_params(std::index_sequence<Index...>) {
    return cat_params(std::get<Index>(modules_).params()...);
  }

  template <size_t... Index>
  const auto& forward_compose(const Chain::input_t& args, std::index_sequence<Index...>) {
    (
        [&]() {
          if constexpr (Index > 0) {
            std::get<Index>(module_outputs_)
                = std::get<Index>(modules_).forward(std::get<Index - 1>(module_outputs_));
          } else {
            std::get<0>(module_outputs_) = std::get<0>(modules_).forward(args);
          }
        }(),
        ...);

    return std::get<len - 1>(module_outputs_);
  }

  template <size_t... Index>
  const auto& backward_compose(
      const Chain::output_t& args, std::index_sequence<Index...>) {

    (
        [&]() {
          if constexpr (Index < len - 1) {
            std::get<Index>(module_d_inputs_) = std::get<Index>(modules_).backward(
                std::get<Index + 1>(module_d_inputs_));
          } else {
            std::get<Index>(module_d_inputs_) = std::get<Index>(modules_).backward(args);
          }
        }(),
        ...);

    return std::get<0>(module_d_inputs_);
  }

  static constexpr std::string _repr(index_t level = 0) {
    auto make_indent = [](index_t n) {
      return std::string(2 * n, ' ');
    };

    index_t i = 0;

    return make_indent(level) + "Chain<\n"
           + (...
               + ([&level, &make_indent]() {
                   if constexpr (ChainKind<ModuleT>)
                     return ModuleT::_repr(level + 1);
                   else
                     return make_indent(level + 1) + ModuleT::repr();
                 }()
                   +
                   [&i] {
                     return i++ > 0 ? ",\n" : "\n";
                   }()))
           + make_indent(level) + ">";
  }
};

}  // namespace konch

#endif  // _KONCH_CHAIN_CHAIN_
