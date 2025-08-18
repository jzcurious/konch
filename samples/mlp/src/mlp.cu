#include <iostream>
#include <konch/core.cuh>

#include "offload/add_bias.cuh"
#include "offload/matmul_wmma.cuh"
#include "offload/reduce_columns.cuh"
#include "offload/relu.cuh"

using namespace konch;

template <AtomKind AtomT, index_t m, index_t n, index_t k>
struct Linear : Module<I<Tens<AtomT, m, k>>, O<Tens<AtomT, m, n>>> {
 private:
  Parameter<Tens<AtomT, k, n>> w;
  Parameter<Tens<AtomT, n>> b;

  State<AtomT, m, n> y;
  State<AtomT, m, k> dx;

 public:
  auto params() {
    return Parameters(w, b);
  }

  Linear::output_t forward(const Linear::input_t& args) {
    this->keep_input(args);

    auto [x] = args.values();

    MatmulWMMAOffload::run<MatmulWMMAConfig{
        .block = {16, 16},
        .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)}
    }>(y, x, w);

    AddBiasOffload::run<AddBiasConfig{
        .block = {128}, .grid = {grid_cover_by_axis(n, 128)}}>(y, y, b);

    return y;
  }

  Linear::input_t backward(const Linear::output_t& args) {
    auto [dy] = args.values();
    auto [x] = this->input_ctx.values();

    /* dL/dx */
    MatmulWMMAOffload::run<MatmulWMMAConfig{
        .block = {16, 16},
        .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)},
        .wmma_colmajor_b = true
    }>(dx, dy, w.value.transpose());

    /* dL/dw */
    MatmulWMMAOffload::run<MatmulWMMAConfig{
        .block = {16, 16},
        .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)},
        .wmma_colmajor_a = true
    }>(w.grad, x.transpose(), dy);

    /* dL/db */
    ReduceColumnsOffload::run<ReduceColumnsConfig{
        .block = {16},
        .grid = {grid_cover_by_axis(n, 16)},
    }>(b.grad, dy);

    return dx;
  }
};

template <AtomKind AtomT, index_t m, index_t n>
struct ReLU : Module<IO<Tens<AtomT, m, n>>> {
 private:
  State<AtomT, m, n> y;
  State<AtomT, m, n> dx;

 public:
  ReLU::output_t forward(const ReLU::input_t& args) {
    auto [x] = args.values();

    ReLUOffload::run<ReLUConfig{
        .block = {16, 16},
        .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)},
    }>(y, x);

    return y;
  }

  ReLU::input_t backward(const ReLU::output_t& args) {
    auto [dy] = args.values();

    ReLUOffload::run<ReLUConfig{
        .block = {16, 16},
        .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)},
    }>(dx, dy);

    return dx;
  }
};

// clang-format off
using MLP = Chain<
  Linear<half, 32, 256, 512>,
  ReLU<half, 32, 256>,
  Linear<half, 32, 128, 256>,
  ReLU<half, 32, 128>
>;
// clang-format on

using MLPLoss = Loss<MLP, O<Scal<half>>>;
using MLPTrainer = Trainer<MLP, MLPLoss>;

int main() {
  typename MLP::input_t::tensor_t<0> x;

  MLP mlp;

  auto [y] = mlp.forward(x).values();

  auto [dx] = mlp.backward(y).values();

  auto params = mlp.params();

  std::cout << MLP::repr() << std::endl;

  // ...

  MLPTrainer trainer(mlp);

  trainer.step(x, y);
}
