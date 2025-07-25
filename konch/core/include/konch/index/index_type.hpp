#ifndef _KONCH_INDEX_TYPE_
#define _KONCH_INDEX_TYPE_

#include <concepts>  // IWYU pragma: keep
#include <cstdint>

namespace konch {

using index_t = std::uint32_t;

template <class T>
concept IndexType = std::is_convertible_v<T, index_t>;

template <auto x>
concept PositiveIndex = IndexType<decltype(x)> and x > 0;

}  // namespace konch

#endif  // _KONCH_INDEX_TYPE_
