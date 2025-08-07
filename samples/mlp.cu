#include <konch/core.cuh>
#include <konch/kernel_add_bias.cuh>
#include <konch/kernel_matmul_wmma.cuh>
#include <konch/kernel_reduce_columns.cuh>
#include <konch/kernel_relu.cuh>

using namespace konch;

template <AtomKind AtomT, index_t m, index_t n, index_t k>
struct Linear : Module<I<Tensor<AtomT, m, k>>, O<Tensor<AtomT, m, n>>> {
 private:
  Parameter<AtomT, k, n> w;
  Parameter<AtomT, n> b;

  State<AtomT, m, n> y;
  State<AtomT, m, k> dx;

 public:
  Linear::output_t forward(const Linear::input_t& args) {
    this->keep_input(args);

    auto [x] = args.values();

    KernelMatmulWMMALauncher::launch<MatmulWMMAConfig{
        .block = {16, 16},
        .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)}
    }>(y, x, w);

    KernelAddBiasLauncher::launch<AddBiasConfig{
        .block = {128}, .grid = {grid_cover_by_axis(n, 128)}}>(y, y, b);

    return y;
  }

  Linear::input_t backward(const Linear::output_t& args) {
    auto [dy] = args.values();
    auto [x] = this->input_ctx.values();

    /* dL/dx */
    KernelMatmulWMMALauncher::launch<MatmulWMMAConfig{
        .block = {16, 16},
        .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)},
        .wmma_colmajor_b = true
    }>(dx, dy, w);  // TODO: transpose w

    /* dL/dw */
    KernelMatmulWMMALauncher::launch<MatmulWMMAConfig{
        .block = {16, 16},
        .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)},
        .wmma_colmajor_a = true
    }>(w.grad, x, dy);  // TODO: transpose x

    /* dL/db */
    KernelReduceColumnsLauncher::launch<ReduceColumnsConfig{
        .block = {16},
        .grid = {grid_cover_by_axis(n, 16)},
    }>(b.grad, dy);

    return dx;
  }
};

template <AtomKind AtomT, index_t m, index_t n>
struct ReLU : Module<IO<Tensor<AtomT, m, n>>> {
 private:
  State<AtomT, m, n> y;
  State<AtomT, m, n> dx;

 public:
  ReLU::output_t forward(const ReLU::input_t& args) {
    auto [x] = args.values();

    KernelReLULauncher::launch<ReLUConfig{
        .block = {16, 16},
        .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)},
    }>(y, x);

    return y;
  }

  ReLU::input_t backward(const ReLU::output_t& args) {
    auto [dy] = args.values();

    KernelReLULauncher::launch<ReLUConfig{
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

int main() {
  typename MLP::input_t::tensor_t<0> x;

  MLP mlp;

  auto [y] = mlp.forward(x);

  auto [dx] = mlp.backward(y);

  // ...
}
