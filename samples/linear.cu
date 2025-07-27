#include <konch/core.cuh>
#include <konch/kernel_add_bias.cuh>
#include <konch/kernel_matmul_wmma.cuh>

using namespace konch;

template <AtomKind AtomT, index_t m, index_t n, index_t k>
struct Linear
    : Module<ModuleInput<Tensor<AtomT, m, k>>, ModuleOutput<Tensor<AtomT, m, n>>> {

 private:
  // TODO: Initialize weights and biases
  Tensor<AtomT, k, n> w_;
  Tensor<AtomT, n> b_;
  Tensor<AtomT, m, n> y_;

 public:
  const auto& forward() {
    auto [x] = this->input.value;

    KernelMatmulWMMALauncher::launch<MatmulWMMAConfig{
        .block = {16, 16},
        .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)}
    }>(y_, *x, w_);

    KernelAddBiasLauncher::launch<AddBiasConfig{
        .block = {128}, .grid = {grid_cover_by_axis(n, 128)}}>(y_, y_, b_);

    return this->output(y_);
  }
};

using Linear1 = Linear<half, 256, 128, 64>;

KONCH_REGISTER_MODULE(Linear1);

int main() {
  Linear1 linear;
  Tensor<half, 256, 64> x;

  linear.input(x);
  linear.forward();

  auto [y] = linear.output.value;

  // ...
}
