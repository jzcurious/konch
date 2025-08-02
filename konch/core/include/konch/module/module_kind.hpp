#ifndef _MODULE_KIND_
#define _MODULE_KIND_

#include "./joint.cuh"

namespace konch::internal {

template <class T>
concept ModuleInputRefKind
    = std::is_reference_v<T> and ModuleInputKind<std::remove_reference_t<T>>;

template <class T>
concept ModuleOutputRefKind
    = std::is_reference_v<T> and ModuleOutputKind<std::remove_reference_t<T>>;

}  // namespace konch::internal

namespace konch {

template <class T>
concept ModuleKind = ModuleInputKind<typename T::input_t>
                     and ModuleOutputKind<typename T::output_t> and requires(T x) {
                           { x.input } -> internal::ModuleInputRefKind;
                           { x.output } -> internal::ModuleOutputRefKind;
                         } and requires(T x, const typename T::input_t& args) {
                           { x(args) } -> internal::ModuleOutputRefKind;
                         } and requires { typename T::parameters_t; };

template <class T>
concept ChainModuleKind
    = ModuleKind<T> and requires { typename T::chain_module_manual_feature; };

template <class T>
concept AtomicModuleKind = ModuleKind<T> and not ChainModuleKind<T>;

}  // namespace konch

#endif  // _MODULE_KIND_
