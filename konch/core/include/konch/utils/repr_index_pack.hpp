#ifndef _KONCH_REPR_INDEDX_PACK_
#define _KONCH_REPR_INDEDX_PACK_

#include "../index/index_type.hpp"

#include <string>

namespace konch::utils {

template <IndexType auto... index_pack>
constexpr std::string repr_index_pack() {
  std::string result = "";
  size_t i = 0;
  (
      [&]() {
        if (i++ > 0) result += ",";
        result += std::to_string(index_pack);
      }(),
      ...);
  return result;
}

}  // namespace konch::utils

#endif  // _KONCH_REPR_INDEDX_PACK_
