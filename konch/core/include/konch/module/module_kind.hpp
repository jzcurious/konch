#ifndef _MODULE_KIND_
#define _MODULE_KIND_

#include "./context_kind.hpp"
#include "./joint.cuh"

namespace konch::internal {

template <class T>
concept ModuleInputRefKind
    = std::is_reference_v<T> and ModuleInputKind<std::remove_reference_t<T>>;

template <class T>
concept ModuleOutputRefKind
    = std::is_reference_v<T> and ModuleOutputKind<std::remove_reference_t<T>>;

template <class T>
concept ModuleInputContextRefKind
    = ModuleInputKind<typename std::remove_reference_t<T>::joint_t>
      and ContextKind<std::remove_reference_t<T>>;

template <class T>
concept ModuleOutputContextRefKind
    = ModuleOutputKind<typename std::remove_reference_t<T>::joint_t>
      and ContextKind<std::remove_reference_t<T>>;

}  // namespace konch::internal

namespace konch {

template <class T>
concept ModuleKind
    = requires { typename T::module_manual_feature; }
      and ModuleInputKind<typename T::input_t> and ModuleOutputKind<typename T::output_t>
      and requires(T x, const typename T::input_t& args) {
            { x.forward(args) } -> ModuleOutputKind;
            { x.input_ctx } -> internal::ModuleInputContextRefKind;
            { x.output_ctx } -> internal::ModuleOutputContextRefKind;
          };

template <class T>
concept TrainableModuleKind
    = ModuleKind<T> and requires(T x, const typename T::output_t& args) {
        { x.backward(args) } -> ModuleInputKind;
      };

template <class T>
concept ChainModuleKind
    = ModuleKind<T> and requires { typename T::chain_module_manual_feature; };

template <class T>
concept AtomicModuleKind = ModuleKind<T> and not ChainModuleKind<T>;
}  // namespace konch

#endif  // _MODULE_KIND_
