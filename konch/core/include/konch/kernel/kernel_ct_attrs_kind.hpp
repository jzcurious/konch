#ifndef _KONCH_KERNEL_CT_ATTRS_KIND_
#define _KONCH_KERNEL_CT_ATTRS_KIND_

#include <concepts>  // IWYU pragma: keep

namespace konch {

template <class T>
concept KernelAttrsCTKind = requires { typename T::kernel_attrs_ct_manual_ferature; };

}  // namespace konch

#endif  // _KONCH_KERNEL_CT_ATTRS_KIND_
