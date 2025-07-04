#ifndef _KONCH_MODULE_STATE_KIND_
#define _KONCH_MODULE_STATE_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept ModuleStateKind = requires { typename T::module_state_manual_feature; };

}  // namespace konch

#endif  // _KONCH_MODULE_STATE_KIND_
