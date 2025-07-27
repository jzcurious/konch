#ifndef _KONCH_KERNEL_LAUNCHER_
#define _KONCH_KERNEL_LAUNCHER_

#include "./kernel.cuh"  // IWYU pragma: keep
#include "./kernel_launcher_kind.hpp"  // IWYU pragma: export

namespace konch {

template <class T>
concept Accessible = AccessorKind<typename T::accessor_t> or AccessorKind<T>;

template <Accessible T>
struct decay_to_accessor {
  using type = std::conditional_t<AccessorKind<T>, T, typename T::accessor_t>;
};

template <Accessible T>
using decay_to_accessor_t = typename decay_to_accessor<T>::type;

template <class KernelLauncherDerivedT>
struct KernelLauncher {

  struct kernel_launcher_manual_feature {};

  template <KernelConfigKind auto config, Accessible ResultT, Accessible... ArgT>
  static void launch(ResultT& result, const ArgT&... args) {
    KernelLauncherDerivedT::template launch<config>(result, args...);
  }
};

}  // namespace konch

#define KONCH_REGISTER_KERNEL_LAUNCHER(launcher_name, kernel_name, config_type)          \
  struct launcher_name : konch::KernelLauncher<launcher_name> {                          \
    template <config_type config, konch::Accessible ResultT, konch::Accessible... ArgT>  \
    static void launch(ResultT& result, const ArgT&... args) {                           \
      static_assert(konch::KernelKind<decltype(kernel_name<config,                       \
                                          konch::decay_to_accessor_t<ResultT>,           \
                                          konch::decay_to_accessor_t<ArgT>...>),         \
          ResultT,                                                                       \
          ArgT...>); /* TODO: add error message here */                                  \
                                                                                         \
      kernel_name<config><<<config.grid, config.block, config.shmem, config.stream>>>(   \
          static_cast<konch::decay_to_accessor_t<ResultT>>(result),                      \
          static_cast<konch::decay_to_accessor_t<ArgT>>(args)...);                       \
    }                                                                                    \
  }

#endif  // _KONCH_KERNEL_LAUNCHER_
