#ifndef _KONCH_MODULE_JOINT_
#define _KONCH_MODULE_JOINT_

#include "konch/tensor/tensor.cuh"
#include "konch/view/view.cuh"

#include <functional>
#include <tuple>

namespace konch {

struct module_input {};

struct module_output {};

template <class T>
concept ModuleJointModeKind
    = std::is_same_v<T, module_input> or std::is_same_v<T, module_output>;

template <ModuleJointModeKind ModeT, AtomKind AtomT, ViewKind... ViewT>
struct ModuleJoint {
  struct module_joint_manual_feature {};

  using mode_t = ModeT;
  using atom_t = AtomT;
  using view_t = ViewsTypeList<ViewT...>;

  std::tuple<std::reference_wrapper<ViewT>...> value;
};

template <AtomKind AtomT, ViewKind... ViewT>
using ModuleInput = ModuleJoint<module_input, AtomT, ViewT...>;

template <AtomKind AtomT, ViewKind... ViewT>
using ModuleOutput = ModuleJoint<module_output, AtomT, ViewT...>;

template <class T>
concept ModuleInputKind
    = ModuleJointModeKind<T> and std::is_same_v<typename T::mode_t, module_input>;

template <class T>
concept ModuleOutputKind
    = ModuleJointModeKind<T> and std::is_same_v<typename T::mode_t, module_output>;

}  // namespace konch

#endif  // _KONCH_MODULE_JOINT_
