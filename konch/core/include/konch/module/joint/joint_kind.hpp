#ifndef _KONCH_MODULE_JOINT_KIND_
#define _KONCH_MODULE_JOINT_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept ModuleJointKind = requires {
  typename T::module_joint_manual_feature;
  { T::repr() } -> std::same_as<std::string>;
};

}  // namespace konch

#endif  // _KONCH_MODULE_JOINT_KIND_
