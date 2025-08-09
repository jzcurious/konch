#ifndef _KONCH_OFFLOAD_
#define _KONCH_OFFLOAD_

#include "../kernel/kernel.cuh"  // IWYU pragma: keep
#include "./offload_kind.hpp"  // IWYU pragma: export

namespace konch {

template <class T>
concept Accessible = AccessorKind<typename T::accessor_t> or AccessorKind<T>;

template <class OffloadDerivedT>
struct Offload {
  struct offload_manual_feature {};

  template <OffloadConfigKind auto config, Accessible ResultT, Accessible... ArgT>
  static void run(ResultT& result, const ArgT&... args) {
    OffloadDerivedT::template run<config>(result, args...);
  }
};

}  // namespace konch

#define KONCH_REGISTER_OFFLOAD(offload_name, kernel_name, config_type)                   \
  struct offload_name : konch::Offload<offload_name> {                                   \
    template <config_type config, konch::Accessible ResultT, konch::Accessible... ArgT>  \
    static void run(ResultT& result, const ArgT&... args) {                              \
                                                                                         \
      kernel_name<config><<<config.grid, config.block, config.shmem, config.stream>>>(   \
          static_cast<ResultT::accessor_t>(result),                                      \
          static_cast<ArgT::accessor_t>(args)...);                                       \
    }                                                                                    \
  }

#endif  // _KONCH_OFFLOAD_
