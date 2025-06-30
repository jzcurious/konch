#ifndef _KONCH_MODULE_INPUT_
#define _KONCH_MODULE_INPUT_

#include "konch/view/view.cuh"

namespace konch {

template <ViewKind ViewT>
class ModuleInput {
 private:
  ViewT view_;

 public:
  ModuleInput(const ViewT& view)
      : view_(view) {}

  ModuleInput(const ModuleInput& input)
      : view_(input.view_) {}
};

}  // namespace konch

#endif  // _KONCH_MODULE_INPUT_
