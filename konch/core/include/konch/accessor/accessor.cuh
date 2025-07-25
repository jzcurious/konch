#ifndef _KONCH_ACCESSOR_
#define _KONCH_ACCESSOR_

#include "../atom/atom_kind.hpp"
#include "../index/index_type.hpp"
#include "../view/view_kind.hpp"

#include "./accessor_kind.hpp"  // IWYU pragma: export

namespace konch {

template <AtomKind AtomT, ViewKind ViewT>
class Accessor final {
 private:
  AtomT* data_;

 public:
  struct accessor_manual_feature {};

  using atom_t = AtomT;
  using accessor_t = Accessor<AtomT, ViewT>;

  const ViewT view;

  Accessor(AtomT* data, const ViewT& view)
      : data_(data)
      , view(view) {}

  __device__ AtomT& operator[](index_t index) {
    return data_[index];
  }

  __device__ AtomT operator[](index_t index) const {
    return data_[index];
  }

  template <IndexType... IndexT>
  __device__ AtomT& operator()(IndexT... indices) {
    return data_[view(indices...)];
  }

  template <IndexType... IndexT>
  __device__ AtomT operator()(IndexT... indices) const {
    return data_[view(indices...)];
  }

  template <IndexType... IndexT>
  __host__ __device__ AtomT* data(IndexT... indices) {
    return &data_[view(indices...)];
  }

  template <IndexType... IndexT>
  __host__ __device__ AtomT* data(IndexT... indices) const {
    return &data_[view(indices...)];
  }
};

}  // namespace konch

#endif  // _KONCH_ACCESSOR_
