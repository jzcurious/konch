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
  struct meta {
    static constexpr const index_t naxis = sizeof...(_sizes);
    static constexpr const std::array<index_t, naxis> sizes = {_sizes...};
    static constexpr const bool is_scalar = naxis == 0;
    static constexpr const index_t numel = is_scalar ? 1 : (_sizes * ...);

    static constexpr const auto strides = [] {
      std::array<index_t, naxis> result{};

      index_t stride = 1;
      result[naxis - 1] = 1;

      for (index_t axis = naxis - 1; axis > 0; --axis)
        result[axis - 1] = (stride *= sizes[axis]);

      return result;
    }();
  };

  const index_t naxis = meta::naxis;
  const std::array<index_t, meta::naxis> sizes = meta::sizes;
  const bool is_scalar = meta::is_scalar;
  const index_t numel = meta::numel;
  const std::array<index_t, meta::naxis> strides = meta::strides;

  __host__ __device__ index_t size(index_t axis = 0) const {
    if constexpr (meta::is_scalar) {
      return 0;
    } else {
      return axis < naxis ? sizes[axis] : 0;
    }
  }

  template <IndexType auto... new_order>
    requires((PositiveIndex<_sizes> and ...) and sizeof...(new_order) == meta::naxis)
  auto permute() const {
    return TensorView<meta::sizes[new_order]...>();
  }

  template <IndexType... IndexT>
    requires(sizeof...(IndexT) == meta::naxis)
  __host__ __device__ index_t operator()(IndexT... indices) const {
    if constexpr (meta::is_scalar) {
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
