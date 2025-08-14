#ifndef _KONCH_TRAINER_KIND_
#define _KONCH_TRAINER_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept TrainerKind = requires { typename T::trainer_manual_feature; };

}  // namespace konch

#endif  // _KONCH_TRAINER_KIND_
