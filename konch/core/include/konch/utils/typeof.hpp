#ifndef _KONCH_TYPEOF_
#define _KONCH_TYPEOF_

#include <string_view>

namespace konch::utils {

template <class T>
consteval std::string_view type_of() {
  std::string_view pretty = __PRETTY_FUNCTION__;

#ifdef __clang__
  constexpr std::string_view needle = "[T = ";
  size_t start = pretty.find(needle);
  if (start == std::string_view::npos) return "unknown";
  start += needle.size();
  size_t end = pretty.find(']', start);
#elif defined(__GNUC__)
  constexpr std::string_view needle = "[with T = ";
  size_t start = pretty.find(needle);
  if (start == std::string_view::npos) return "unknown";
  start += needle.size();
  size_t end = pretty.find(';', start);
#else
  return "unknown";
#endif

  if (end != std::string_view::npos && start < end) {
    std::string_view type_name = pretty.substr(start, end - start);
    return type_name;
  }
  return "unknown";
}

}  // namespace konch::utils

#endif  // _KONCH_TYPEOF_
