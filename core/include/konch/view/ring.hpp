#ifndef _KONCH_RING_
#define _KONCH_RING_

#include "konch/index/index_type.hpp"

namespace konch {

inline index_t ring(index_t index, index_t size) {
  return index < size ? index : index % size;
}

}  // namespace konch

#endif  // _KONCH_RING_
