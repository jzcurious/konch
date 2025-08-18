#ifndef _KONCH_TENSOR_
#define _KONCH_TENSOR_

#include "../accessor/accessor.cuh"
#include "../atom/atom_kind.hpp"
#include "../block/block.cuh"
#include "../utils/typeof.hpp"
#include "../view/view.cuh"
#include "./tensor_kind.hpp"  // IWYU pragma: export

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

  template <ViewKind ViewT>
  Tensor(Block<AtomT>& block, const ViewT& view)
      : block_(block)
      , accessor_(block_.data(), view) {}

  template <ViewKind ViewT>
  Tensor(const Block<AtomT>& block, const ViewT& view)
      : block_(block)
      , accessor_(block_.data(), view) {}

 public:
  Tensor()
      : block_(view_t::meta::numel)
      , accessor_(block_.data(), view_t()) {}

  view_t& view() const {
    return accessor_.view;
  }

  accessor_t& accessor() {
    return accessor_;
  }

  const accessor_t& accessor() const {
    return accessor_;
  }

  operator accessor_t&() {
    return accessor_;
  }

  operator const accessor_t&() const {
    return accessor_;
  }

  template <ViewKind ViewT>
    requires(ViewT::meta::numel == view_t::meta::numel)
  accessor_t review(const ViewT& view) {
    return accessor_t(block_.data(), view);
  }

  template <ViewKind ViewT>
    requires(ViewT::meta::numel == view_t::meta::numel)
  const accessor_t review(const ViewT& view) const {
    return accessor_t(const_cast<AtomT*>(block_.data()), view);
  }

  template <IndexType auto... new_order>
  auto permute() const {
    return this->review(accessor_.view.template permute<new_order...>());
  }

  auto transpose() {
    // TODO: case Scalar
    return permute<0, 1>();
  }

  auto transpose() const {
    // TODO: case Scalar
    return permute<0, 1>();
  }

  static constexpr std::string repr() {
    if constexpr (sizeof...(sizes) == 0)
      return "Scalar<" + utils::type_of<AtomT>() + ">";
    else if constexpr (sizeof...(sizes) == 1)
      return "Vector<" + utils::type_of<AtomT>() + ", "
             + utils::repr_values_pack<sizes...>() + ">";
    else
      return "Tensor<" + utils::type_of<AtomT>() + ", "
             + utils::repr_values_pack<sizes...>() + ">";
  }
};

template <AtomKind AtomT, index_t... sizes>
using Tens = Tensor<AtomT, sizes...>;

template <AtomKind AtomT, index_t len>
  requires(len > 0)
using Vector = Tensor<AtomT, len>;

template <AtomKind AtomT, index_t len>
using Vec = Vector<AtomT, len>;

template <AtomKind AtomT>
using Scalar = Tensor<AtomT>;

template <AtomKind AtomT>
using Scal = Tensor<AtomT>;

}  // namespace konch

#endif  // _KONCH_TENSOR_
