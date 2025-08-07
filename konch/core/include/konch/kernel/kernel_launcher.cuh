#ifndef _KONCH_KERNEL_LAUNCHER_
#define _KONCH_KERNEL_LAUNCHER_

#include "./kernel.cuh"  // IWYU pragma: keep
#include "./kernel_launcher_kind.hpp"  // IWYU pragma: export

namespace konch {

template <class T>
concept Accessible = AccessorKind<typename T::accessor_t> or AccessorKind<T>;

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
                                                                                         \
      kernel_name<config><<<config.grid, config.block, config.shmem, config.stream>>>(   \
          static_cast<ResultT::accessor_t>(result),                                      \
          static_cast<ArgT::accessor_t>(args)...);                                       \
    }                                                                                    \
  }

#endif  // _KONCH_KERNEL_LAUNCHER_
