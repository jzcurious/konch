#ifndef _KONCH_STATE_
#define _KONCH_STATE_

#include "../../tensor/tensor.cuh"
#include "./state_kind.hpp"  // IWYU pragma: export

namespace konch {

template <AtomKind AtomT, index_t... sizes>
using State = Tensor<AtomT, sizes...>;

}  // namespace konch

#endif  // _KONCH_STATE_
