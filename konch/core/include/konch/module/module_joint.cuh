#ifndef _KONCH_MODULE_JOINT_
#define _KONCH_MODULE_JOINT_

#include "konch/module/module_joint_kind.hpp"
#include "konch/tensor/tensor.cuh"

#include <functional>
#include <tuple>

namespace konch {

struct module_input {};

struct module_output {};

template <class T>
concept ModuleJointModeKind
    = std::is_same_v<T, module_input> or std::is_same_v<T, module_output>;

template <ModuleJointModeKind ModeT, TensorKind... TensorT>
struct ModuleJoint {
  struct module_joint_manual_feature {};

  using mode_t = ModeT;
  using view_t = ViewsTypeList<typename TensorT::view_t...>;
  using value_t = std::tuple<std::reference_wrapper<TensorT>...>;

  value_t value;

  void set(const TensorT&... tensor) {
    static_assert(std::is_same_v<mode_t, module_input>, "");  // TODO: add message
    std::tie(value) = std::tie(tensor...);  // PROBLEM: type miss
  }

  void set(TensorT&... tensor) {
    static_assert(std::is_same_v<mode_t, module_output>, "");  // TODO: add message
    std::tie(value) = std::tie(tensor...);
  }

  void set(const ModuleJoint& joint) {
    static_assert(std::is_same_v<mode_t, module_input>, "");  // TODO: add message
    std::tie(value) = std::tie(joint.value);
  }

  void set(ModuleJoint& joint) {
    static_assert(std::is_same_v<mode_t, module_input>, "");  // TODO: add message
    std::tie(value) = std::tie(joint.value);
  }

  template <ModuleJointKind ModuleJointT>
  bool operator==(const ModuleJointT&) const {
    return std::is_same_v<ModuleJoint, ModuleJointT>;
  }

  template <ModuleJointKind ModuleJointT>
  bool check_compatibility(ModuleJointT) {
    if constexpr (std::is_same_v<typename ModuleJointT::mode_t, mode_t>) {
      return false;
    } else {
      return std::is_same_v<typename ModuleJointT::value_t, value_t>;
    }
  }
};

template <TensorKind... TensorT>
using ModuleInput = ModuleJoint<module_input, TensorT...>;

template <TensorKind... TensorT>
using ModuleOutput = ModuleJoint<module_output, TensorT...>;

template <class T>
concept ModuleInputKind
    = ModuleJointModeKind<T> and std::is_same_v<typename T::mode_t, module_input>;

template <class T>
concept ModuleOutputKind
    = ModuleJointModeKind<T> and std::is_same_v<typename T::mode_t, module_output>;

}  // namespace konch

#endif  // _KONCH_MODULE_JOINT_
