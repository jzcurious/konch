#ifndef _KONCH_CONTEXT_
#define _KONCH_CONTEXT_

#include "../joint/joint_kind.hpp"
#include "./context_kind.hpp"  // IWYU pragma: export

namespace konch {

template <ModuleJointKind JointT>
struct Context {
  struct context_manual_feature {};

  using joint_t = JointT;

 private:
  bool actual_ = false;
  JointT joint_;

 public:
  bool is_actual() const {
    return actual_;
  }

  const auto values() const {
    return joint_.values();
  }

  JointT& operator()(const JointT& joint) {
    actual_ = true;
    joint_ = joint;
    return joint_;
  }

  operator JointT&() {
    return joint_;
  }

  operator const JointT&() const {
    return joint_;
  }
};

}  // namespace konch

#endif  // _KONCH_CONTEXT_
