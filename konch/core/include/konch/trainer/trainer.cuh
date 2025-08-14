#ifndef _KONCH_TRAINER_
#define _KONCH_TRAINER_

#include "../loss/loss_kind.hpp"
#include "../module/module/module_kind.hpp"
#include "./trainer_kind.hpp"  // IWYU pragma: export

namespace konch {

template <ModuleKind ModuleT, LossKind LossT>
struct Trainer {
  struct trainer_manual_feature {};

  using input_t = typename ModuleT::input_t;
  using target_t = typename ModuleT::output_t::complement_t;

 private:
  ModuleT& module_;
  LossT loss_;

 public:
  Trainer(ModuleT& module)
      : module_(module)
      , loss_() {}

  void step(const input_t& input, const target_t& target) {
    auto loss_value = loss_.forward(module_.forward(input));
    module_.backward(loss_.backward(loss_value));
    module_.params().update();
  }

  // TODO: Train loop with a data provider
};

}  // namespace konch

#endif  // _KONCH_TRAINER_
