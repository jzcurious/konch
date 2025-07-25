#ifndef _KONCH_KERNEL_LAUNCHER_
#define _KONCH_KERNEL_LAUNCHER_

#include "../tensor/tensor_kind.hpp"
#include "./kernel.cuh"  // IWYU pragma: keep
#include "./kernel_config.hpp"

#include "./kernel_launcher_kind.hpp"  // IWYU pragma: export

namespace konch {

// template <class T>
// concept LaunchArgKind = AccessorKind<T> or TensorKind<T>;

template <class KernelLauncherDerivedT>
struct KernelLauncher {

  struct kernel_launcher_manual_feature {};

  template <KernelConfigKind auto config, AccessorKind ResultT, AccessorKind... ArgT>
  static void launch(ResultT& result, const ArgT&... args) {
    KernelLauncherDerivedT::template launch<config>(result, args...);
  }
};

}  // namespace konch

// #define KONCH_REGISTER_KERNEL_LAUNCHER(launcher_name, kernel_name)
//   struct launcher_name : konch::KernelLauncher<launcher_name> {
//     template <konch::KernelConfigKind auto config,
//         konch::AccessorKind ResultT,
//         konch::AccessorKind... ArgT>
//     static void launch(ResultT& result, const ArgT&... args) {
//       kernel_name<config>
//           <<<config.grid, config.block, config.shmem, config.stream>>>(result,
//           args...);
//     }
//   }

#define KONCH_REGISTER_KERNEL_LAUNCHER(launcher_name, kernel_name)                       \
  struct launcher_name : konch::KernelLauncher<launcher_name> {                          \
    template <konch::KernelConfigKind auto config,                                       \
        konch::AccessorKind ResultT,                                                     \
        konch::AccessorKind... ArgT>                                                     \
    static void launch(ResultT& result, const ArgT&... args) {                           \
      kernel_name<config><<<config.grid, config.block>>>(result, args...);               \
    }                                                                                    \
  }

#endif  // _KONCH_KERNEL_LAUNCHER_
