#ifndef _KONCH_INDEX_TYPE_
#define _KONCH_INDEX_TYPE_

#include <concepts>  // IWYU pragma: keep
#include <cstdint>

namespace konch {

using index_t = std::uint32_t;

template <class T>
concept IndexType = std::is_same_v<index_t, T>;

template <class T>
concept PositiveIndex = IndexType<T> and requires(T x) {
  { x > 0 } -> std::same_as<bool>;
};

}  // namespace konch

#endif  // _KONCH_INDEX_TYPE_
