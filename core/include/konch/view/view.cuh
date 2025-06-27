#ifndef _KONCH_VIEW_
#define _KONCH_VIEW_

#include "konch/index/index_type.hpp"
#include "konch/view/view_kind.hpp"  // IWYU pragma: export

namespace konch {

template <index_t num_axis>
class TensorView final {
 public:
  struct view_manual_feature {};

  const index_t naxis = num_axis;

 private:
  index_t sizes_[num_axis];
  index_t strides_[num_axis];

 public:
  template <IndexType... SizeT>
  __host__ TensorView(SizeT... sizes) {
    // TODO: check the ctor

    static_assert(sizeof...(sizes) == num_axis,
        "Number of axes must match the number of arguments");

    index_t axis = 0;
    ((sizes_[axis] = sizes, ++axis), ...);

    index_t stride = 1;
#pragma unroll
    for (index_t axis = num_axis - 1; axis > 0; --axis) {
      strides_[axis - 1] = stride;
      stride *= sizes_[axis];
    }
  }

  template <IndexType... IndexT>
  __host__ __device__ index_t operator()(IndexT... indices) const {
    // TODO: check the shit

    static_assert(sizeof...(indices) == num_axis,
        "Number of axes must match the number of arguments");

    index_t address = 0;
    index_t axis = 0;

    ((address += ring(indices, sizes_[axis]) * strides_[axis], ++axis), ...);
    return address;
  }

  __host__ __device__ index_t size(index_t axis = 0) const {
    return axis < naxis ? sizes_[axis] : 0;
  }
};

template <IndexType... SizeT>
TensorView(SizeT...) -> TensorView<sizeof...(SizeT)>;

using ScalarView = TensorView<0>;
using VectorView = TensorView<1>;
using MatrixView = TensorView<2>;

}  // namespace konch

#endif  // _KONCH_VIEW_
