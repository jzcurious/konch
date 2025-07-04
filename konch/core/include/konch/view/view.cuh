#ifndef _KONCH_VIEW_
#define _KONCH_VIEW_

#include "konch/index/index_type.hpp"
#include "konch/view/view_kind.hpp"  // IWYU pragma: export

#include <array>

namespace konch {

template <PositiveIndex auto... _sizes>
class TensorView final {
 public:
  struct view_manual_feature {};

  static constexpr const index_t naxis = sizeof...(_sizes);
  static constexpr const std::array<index_t, naxis> sizes = {_sizes...};
  static constexpr const bool is_scalar = naxis == 0;
  static constexpr const index_t numel = is_scalar ? 1 : (_sizes * ...);

 private:
  static constexpr const auto strides_ = [] {
    std::array<index_t, naxis> result{};

    index_t stride = 1;
    result[naxis - 1] = 1;

    for (index_t axis = naxis - 1; axis > 0; --axis)
      result[axis - 1] = (stride *= sizes[axis]);

    return result;
  }();

 public:
  template <IndexType... SizeT>
  __host__ TensorView(SizeT... sizes) {}

  __host__ __device__ index_t size(index_t axis = 0) const {
    if constexpr (is_scalar) {
      return 0;
    } else {
      return axis < naxis ? sizes[axis] : 0;
    }
  }

  template <IndexType... IndexT>
  __host__ __device__ index_t operator()(IndexT... indices) const {
    static_assert(sizeof...(indices) == naxis,
        "Number of axes must match the number of arguments.");

    if constexpr (is_scalar) {
      return 0;
    } else {
      index_t address = 0;
      index_t axis = 0;

      ((address += ring(indices, sizes[axis]) * strides_[axis], ++axis), ...);
      return address;
    }
  }

  template <ViewKind ViewT>
  __host__ __device__ bool operator==(const ViewT&) const {
    return std::is_same_v<TensorView, ViewT>;
  }
};

template <PositiveIndex auto... sizes>
TensorView(decltype(sizes)...) -> TensorView<sizes...>;

template <PositiveIndex auto... sizes>
using View = TensorView<sizes...>;

using ScalarView = TensorView<>;

template <index_t len>
using VectorView = TensorView<len>;

template <index_t mrows, index_t ncols>
using MatrixView = TensorView<mrows, ncols>;

}  // namespace konch

#endif  // _KONCH_VIEW_
