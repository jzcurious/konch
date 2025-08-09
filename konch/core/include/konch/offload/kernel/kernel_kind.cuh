#ifndef _KONCH_KERNEL_KIND_
#define _KONCH_KERNEL_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T, class... ArgT>
concept KernelKind = requires(T x, ArgT... args) {
  { x<<<1, 1, 0, 0>>>(args...) } -> std::same_as<void>;
};

}  // namespace konch

#endif  // _KONCH_KERNEL_KIND_
