#ifndef _KONCH_MODULE_JOINT_
#define _KONCH_MODULE_JOINT_

#include "../tensor/tensor.cuh"

#include "./module_joint_kind.hpp"

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
  using value_t = std::tuple<const TensorT*...>;

  static constexpr const bool is_input = std::is_same_v<mode_t, module_input>;
  static constexpr const bool is_output = std::is_same_v<mode_t, module_output>;

  value_t value;

  void set(const TensorT&... tensor) {
    value = std::forward_as_tuple(&tensor...);
  }

  void set(const ModuleJoint& joint) {
    value = joint.value;
  }

  const ModuleJoint& operator()(const TensorT&... tensor) {
    this->set(tensor...);
    return *this;
  }

  const ModuleJoint& operator=(const ModuleJoint& joint) {
    this->set(joint);
    return *this;
  }

  template <ModuleJointKind ModuleJointT>
  bool operator==(const ModuleJointT&) const {
    return std::is_same_v<ModuleJoint, ModuleJointT>;
  }

  template <ModuleJointKind ModuleJointT>
  constexpr bool check_compatibility(ModuleJointT) {
    if (std::is_same_v<typename ModuleJointT::mode_t, mode_t>) return false;
    return std::is_same_v<typename ModuleJointT::value_t, value_t>;
  }

  template <ModuleJointKind ModuleJointT>
  void link(ModuleJointT& other_joint) {
    if constexpr (is_input) {
      set(other_joint.value);
    } else {
      other_joint.set(value);
    }
  }
};

template <TensorKind... TensorT>
using ModuleInput = ModuleJoint<module_input, TensorT...>;

template <TensorKind... TensorT>
using ModuleOutput = ModuleJoint<module_output, TensorT...>;

template <class T>
concept ModuleInputKind
    = ModuleJointKind<T> and std::is_same_v<typename T::mode_t, module_input>;

template <class T>
concept ModuleOutputKind
    = ModuleJointKind<T> and std::is_same_v<typename T::mode_t, module_output>;

template <class T>
concept ModuleInputRefKind
    = std::is_reference_v<T> and ModuleInputKind<std::remove_reference_t<T>>;

template <class T>
concept ModuleOutputRefKind
    = std::is_reference_v<T> and ModuleOutputKind<std::remove_reference_t<T>>;

}  // namespace konch

#endif  // _KONCH_MODULE_JOINT_
