#ifndef _KONCH_KERNEL_LAUNCHER_
#define _KONCH_KERNEL_LAUNCHER_

#include "../tensor/tensor_kind.hpp"
#include "./kernel.cuh"  // IWYU pragma: keep
#include "./kernel_config.hpp"

#include "./kernel_launcher_kind.hpp"  // IWYU pragma: export

namespace konch {

template <class KernelLauncherDerivedT>
struct KernelLauncher {

  struct kernel_launcher_manual_feature {};

  template <KernelConfigKind config, AccessorKind ResultT, AccessorKind... ArgT>
  static void launch(ResultT& result, const ArgT&... args) {
    KernelLauncherDerivedT::template launch<config>(result, args...);
  }
};

}  // namespace konch

#define KONCH_REGISTER_KERNEL_LAUNCHER(launcher_name, kernel_name)                       \
  struct launcher_name : konch::KernelLauncher<launcher_name> {                          \
    template <KernelConfigKind config,                                                   \
        konch::AccessorKind ResultT,                                                     \
        konch::AccessorKind... ArgT>                                                     \
    static void launch(ResultT& result, const ArgT&... args) {                           \
      kernel_name<config><<<config::grid, config::block>>>(result, args...);             \
    }                                                                                    \
  }

#endif  // _KONCH_KERNEL_LAUNCHER_
