#ifndef _KONCH_TENSOR_
#define _KONCH_TENSOR_

#include "konch/accessor/accessor.cuh"
#include "konch/atom/atom_kind.hpp"
#include "konch/block/block.cuh"
#include "konch/tensor/tensor_kind.hpp"  // IWYU pragma: export
#include "konch/view/view.cuh"

namespace konch {

template <AtomKind AtomT, ViewKind ViewT>
class Tensor {
 public:
  using atom_t = AtomT;
  using view_t = ViewT;

 private:
  Block<AtomT> block_;
  Accessor<AtomT, view_t> accessor_;

 public:
  Tensor()
      : block_(view_t::numel)
      , accessor_(block_.data(), view_t()) {}

  Tensor(PositiveIndex auto...)
      : block_(view_t::numel)
      , accessor_(block_.data(), view_t()) {}

  template <AtomKind _AtomT, ViewKind _ViewT>
  static Tensor make() {
    return Tensor<_AtomT, _ViewT>();
  }

  template <AtomKind _AtomT, PositiveIndex auto... sizes>
  static Tensor make() {
    return Tensor<_AtomT, TensorView<sizes...>>();
  }

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

Tensor(PositiveIndex auto... sizes) -> Tensor<float, TensorView<sizes...>>;

}  // namespace konch

#endif  // _KONCH_TENSOR_
