#ifndef _KONCH_MODULE_OUTPUT_
#define _KONCH_MODULE_OUTPUT_

#include "konch/view/view.cuh"

namespace konch {

template <ViewKind ViewT>
class ModuleOutput {
 private:
  ViewT view_;

 public:
  ModuleOutput(const ViewT& view)
      : view_(view) {}

  ModuleOutput(const ModuleOutput& input)
      : view_(input.view_) {}
};

}  // namespace konch

#endif  // _KONCH_MODULE_OUTPUT_
