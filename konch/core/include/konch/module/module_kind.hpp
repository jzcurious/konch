#ifndef _MODULE_KIND_
#define _MODULE_KIND_

#include "./module_joint.cuh"

namespace konch {

template <class T>
concept ModuleKind = ModuleInputKind<typename T::input_t>
                     and ModuleOutputKind<typename T::output_t> and requires(T x) {
                           { x.input } -> ModuleInputRefKind;
                           { x.output } -> ModuleOutputRefKind;
                           { x.forward() } -> ModuleOutputRefKind;
                         };

}  // namespace konch

#endif  // _MODULE_KIND_
