#ifndef _KONCH_GRID_HEURISTICS_CUH_
#define _KONCH_GRID_HEURISTICS_CUH_

#include "../../index/index_type.hpp"

namespace konch {

inline constexpr index_t grid_cover_by_axis(
    std::size_t work_axis_size, index_t block_axis_size) {
  return (work_axis_size + block_axis_size - 1) / block_axis_size;
}

}  // namespace konch

#endif  // _KONCH_GRID_HEURISTICS_CUH_
