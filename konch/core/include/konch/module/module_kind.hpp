#ifndef _MODULE_KIND_
#define _MODULE_KIND_

#include "./module_joint.cuh"

namespace konch {

template <class T>
concept ModuleInputRefKind
    = std::is_reference_v<T> and ModuleInputKind<std::remove_reference_t<T>>;

template <class T>
concept ModuleOutputRefKind
    = std::is_reference_v<T> and ModuleOutputKind<std::remove_reference_t<T>>;

template <class T>
concept ModuleKind = ModuleInputKind<typename T::input_t>
                     and ModuleOutputKind<typename T::output_t> and requires(T x) {
                           { x.input } -> ModuleInputRefKind;
                           { x.output } -> ModuleOutputRefKind;
                         } and requires(T x, const typename T::input_t& args) {
                           { x(args) } -> ModuleOutputRefKind;
                         };

}  // namespace konch

#endif  // _MODULE_KIND_
