#ifndef _KONCH_ATOM_KIND_
#define _KONCH_ATOM_KIND_

#include <concepts>  // IWYU pragma: keep
#include <cuda_bf16.h>
#include <cuda_fp16.h>

namespace konch {

template <class T>
concept AtomKind = std::is_integral_v<T> or std::is_floating_point_v<T>
                   or std::is_same_v<nv_half, T> or std::is_same_v<nv_bfloat16, T>;

}

#endif  // _KONCH_ATOM_KIND_
