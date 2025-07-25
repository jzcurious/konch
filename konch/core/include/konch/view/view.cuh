#ifndef _KONCH_VIEW_
#define _KONCH_VIEW_

#include "../index/index_type.hpp"
#include "./ring.cuh"

#include "./view_kind.hpp"  // IWYU pragma: export

#include <array>

namespace konch {

template <IndexType auto... _sizes>
  requires(PositiveIndex<_sizes> and ...)
class TensorView final {
 public:
  struct view_manual_feature {};

 public:
  static constexpr const index_t naxis_ct = sizeof...(_sizes);
  static constexpr const std::array<index_t, naxis_ct> sizes_ct = {_sizes...};
  static constexpr const bool is_scalar_ct = naxis_ct == 0;
  static constexpr const index_t numel_ct = is_scalar_ct ? 1 : (_sizes * ...);

  static constexpr const auto strides_ct = [] {
    std::array<index_t, naxis_ct> result{};

    index_t stride = 1;
    result[naxis_ct - 1] = 1;

    for (index_t axis = naxis_ct - 1; axis > 0; --axis)
      result[axis - 1] = (stride *= sizes_ct[axis]);

    return result;
  }();

  const index_t naxis = naxis_ct;
  const index_t numel = numel_ct;
  const std::array<index_t, naxis_ct> sizes = sizes_ct;
  const bool is_scalar = is_scalar_ct;
  const std::array<index_t, naxis_ct> strides = strides_ct;

  __host__ __device__ index_t size(index_t axis = 0) const {
    if constexpr (is_scalar_ct) {
      return 0;
    } else {
      return axis < naxis ? sizes[axis] : 0;
    }
  }

  template <IndexType... IndexT>
    requires(sizeof...(IndexT) == naxis_ct)
  __host__ __device__ index_t operator()(IndexT... indices) const {
    if constexpr (is_scalar_ct) {
      return 0;
    } else {
      index_t address = 0;
      index_t axis = 0;

      ((address += ring(indices, sizes[axis]) * strides[axis], ++axis), ...);
      return address;
    }
  }

  template <ViewKind ViewT>
  __host__ __device__ bool operator==(const ViewT&) const {
    return std::is_same_v<TensorView, ViewT>;
  }
};

template <IndexType auto... sizes>
using View = TensorView<sizes...>;

using ScalarView = TensorView<>;

template <index_t len>
using VectorView = TensorView<len>;

template <index_t mrows, index_t ncols>
using MatrixView = TensorView<mrows, ncols>;

}  // namespace konch

#endif  // _KONCH_VIEW_
