#ifndef _KONCH_TENSOR_
#define _KONCH_TENSOR_

#include "../accessor/accessor.cuh"
#include "../atom/atom_kind.hpp"
#include "../block/block.cuh"
#include "../view/view.cuh"

#include "./tensor_kind.hpp"  // IWYU pragma: export

// TODO: add Matrix, Vector and Scalar

namespace konch {

template <AtomKind AtomT, index_t... sizes>
class Tensor {
 public:
  struct tensor_manual_feature {};

  using atom_t = AtomT;
  using view_t = View<sizes...>;
  using accessor_t = Accessor<AtomT, view_t>;

 private:
  Block<AtomT> block_;
  Accessor<AtomT, view_t> accessor_;

 public:
  Tensor()
      : block_(view_t::numel_ct)
      , accessor_(block_.data(), view_t()) {}

  view_t& view() const {
    return accessor_.view;
  }

  Accessor<AtomT, view_t>& accessor() {
    return accessor_;
  }

  const Accessor<AtomT, view_t>& accessor() const {
    return accessor_;
  }

  operator Accessor<AtomT, view_t>() {
    return accessor_;
  }
};

// TODO: add generic tensor

}  // namespace konch

#endif  // _KONCH_TENSOR_
