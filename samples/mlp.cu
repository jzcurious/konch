#include <konch/core.cuh>
#include <konch/kernel_add_bias.cuh>
#include <konch/kernel_matmul_wmma.cuh>
#include <konch/kernel_relu.cuh>

using namespace konch;

template <AtomKind AtomT, index_t m, index_t n, index_t k>
struct Linear : Module<I<Tensor<AtomT, m, k>>, O<Tensor<AtomT, m, n>>> {

  Tensor<AtomT, k, n> w;
  Tensor<AtomT, n> b;
  Tensor<AtomT, m, n> y;

  const auto& operator()(const Linear::input_t& args) {
    this->input(args);

    auto [x] = args.values();

    KernelMatmulWMMALauncher::launch<MatmulWMMAConfig{
        .block = {16, 16},
        .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)}
    }>(y, x, w);

    KernelAddBiasLauncher::launch<AddBiasConfig{
        .block = {128}, .grid = {grid_cover_by_axis(n, 128)}}>(y, y, b);

    return this->output(y);
  }
};

template <AtomKind AtomT, index_t m, index_t n>
struct ReLU : Module<IO<Tensor<AtomT, m, n>>> {
  const auto& operator()(const ReLU::input_t& args) {
    this->input(args);

    auto [x] = args.values();

    KernelReLULauncher::launch<ReLUConfig{
        .block = {128}, .grid = {grid_cover_by_axis(n, 128)}}>(x, x);

    return this->output(x);
  }
};

template <AtomKind AtomT, index_t m, index_t n, index_t k>
using LinearWithReLU = Chain<Linear<AtomT, m, n, k>, ReLU<AtomT, m, n>>;

using MLP
    = Chain<LinearWithReLU<half, 256, 128, 512>, LinearWithReLU<half, 256, 64, 128>>;

using LinearGradient = Gradient<Linear<half, 256, 128, 512>>;

using MLPGradient = Gradient<MLP>;

int main() {
  typename MLP::input_t::tensor_t<0> x;

  MLP mlp;

  auto y = mlp(x);

  // ...
}
