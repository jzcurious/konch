#ifndef _KONCH_MODULE_CONNECTOR_
#define _KONCH_MODULE_CONNECTOR_

#include "konch/module/module_joint_kind.hpp"

namespace konch {

struct ModuleConnector {
  template <ModuleJointKind JointT1, ModuleJointKind JointT2>
  static void connect() {
    static_assert(std::is_same_v<JointT1, JointT2>, "");  // TODO: add message
  }
};

}  // namespace konch

#endif  // _KONCH_MODULE_CONNECTOR_
