#ifndef _KONCH_OBJECT_
#define _KONCH_OBJECT_

#include "konch/accessor/accessor.cuh"
#include "konch/atom/atom_kind.hpp"
#include "konch/block/block.cuh"
#include "konch/view/view.cuh"

namespace konch {

template <index_t naxis, AtomKind AtomT = float>
class Tensor {
 public:
  using ViewT = TensorView<naxis>;

 private:
  Block<AtomT> block_;
  Accessor<AtomT, ViewT> accessor_;

 public:
  template <IndexType... SizeT>
  __host__ Tensor(SizeT... sizes)
      : block_((sizes * ...))
      , accessor_(block_.data(), ViewT(sizes...)) {}

  ViewT& view() const {
    return accessor_.view;
  }

  Accessor<AtomT, ViewT>& accessor() {
    return accessor_;
  }

  const Accessor<AtomT, ViewT>& accessor() const {
    return accessor_;
  }
};

template <IndexType... SizeT>
Tensor(SizeT...) -> Tensor<sizeof...(SizeT)>;

}  // namespace konch

#endif  // _KONCH_OBJECT_
