#ifndef _KONCH_MODULE_JOINT_
#define _KONCH_MODULE_JOINT_

#include "../../tensor/tensor.cuh"
#include "../state/state_kind.hpp"

#include "./joint_kind.hpp"

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
  using lines_t = std::tuple<const TensorT*...>;
  using tensors_t = std::tuple<TensorT...>;

  template <index_t index>
  using tensor_t = std::remove_pointer_t<typename std::tuple_element_t<index, lines_t>>;

  using complement_t = std::conditional_t<std::is_same_v<mode_t, module_input>,
      ModuleJoint<module_output, TensorT...>,
      ModuleJoint<module_input, TensorT...>>;

  lines_t lines;

  ModuleJoint() = default;

  template <class... T>
  ModuleJoint(const T&... args)
    requires((TensorKind<T> or StateKind<T>) or ...)
      : lines(std::forward_as_tuple(&static_cast<const TensorT&>(args)...)) {}

  ModuleJoint(const lines_t& lines)
      : lines(lines) {}

  std::tuple<const TensorT&...> values() const {
    return std::apply(
        [](const auto*... ptrs) { return std::make_tuple(*ptrs...); }, lines);
  }

  const ModuleJoint& operator()(const TensorT&... tensor) {
    lines = std::forward_as_tuple(&tensor...);
    return *this;
  }

  template <ModuleJointKind JointT>
  const ModuleJoint& operator()(const JointT& joint) {
    if constexpr (std::is_same_v<ModuleJoint, JointT>)
      lines = joint.lines;
    else
      lines = static_cast<ModuleJoint>(joint).lines;
    return *this;
  }

  operator const complement_t() const {
    return complement_t(lines);
  }
};

template <TensorKind... TensorT>
using ModuleInput = ModuleJoint<module_input, TensorT...>;

template <TensorKind... TensorT>
using ModuleOutput = ModuleJoint<module_output, TensorT...>;

template <TensorKind... TensorT>
using Input = ModuleJoint<module_input, TensorT...>;

template <TensorKind... TensorT>
using Output = ModuleJoint<module_output, TensorT...>;

template <class T>
concept ModuleInputKind
    = ModuleJointKind<T> and std::is_same_v<typename T::mode_t, module_input>;

template <class T>
concept ModuleOutputKind
    = ModuleJointKind<T> and std::is_same_v<typename T::mode_t, module_output>;

}  // namespace konch

#endif  // _KONCH_MODULE_JOINT_
