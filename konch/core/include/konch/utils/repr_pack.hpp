#ifndef _KONCH_REPR_PACK_
#define _KONCH_REPR_PACK_

#include "./typeof.hpp"
#include <string>

namespace konch::utils {

template <class T>
concept HasReprFunction = requires {
  { T::repr() } -> std::same_as<std::string>;
};

template <auto... pack>
constexpr std::string repr_values_pack() {
  std::string result = "";
  size_t i = 0;
  (
      [&]() {
        if (i++ > 0) result += ",";
        result += std::to_string(pack);
      }(),
      ...);
  return result;
}

template <class... pack>
constexpr std::string repr_types_pack() {
  std::string result = "";
  size_t i = 0;
  (
      [&]() {
        if (i++ > 0) result += ",";
        if constexpr (HasReprFunction<pack>)
          result += pack::repr();
        else
          result += type_of<pack>();
      }(),
      ...);
  return result;
}

}  // namespace konch::utils

#endif  // _KONCH_REPR_PACK_
