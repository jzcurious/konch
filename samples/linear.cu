#include <konch/core.cuh>
#include <konch/kernel_add_bias.cuh>
#include <konch/kernel_matmul_wmma.cuh>

using namespace konch;

template <AtomKind AtomT, index_t m, index_t n, index_t k>
class Linear {
 public:
  using input_t = ModuleInput<Tensor<AtomT, m, k>>;
  using output_t = ModuleOutput<Tensor<AtomT, m, n>>;

 private:
  input_t input_;
  output_t output_;

  // TODO: Initialize weights and biases
  Tensor<AtomT, k, n> w_;
  Tensor<AtomT, n> b_;
  Tensor<AtomT, m, n> y_;

 public:
  input_t& input() {
    return input_;
  }

  const output_t& output() {
    return output_;
  }

  const output_t& forward() {
    auto [x] = input_.value;

    KernelMatmulWMMALauncher::launch<MatmulWMMAConfig{
        .block = {16, 16},
        .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)}
    }>(y_, *x, w_);

    // Seems like NVCC doesn't support this syntax yet (C++20).
    //
    // ```
    // KernelMatmulWMMALauncher::launch<{
    //     .block = {16, 16},
    //     .grid = {grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)}
    // }>(y_, *x, w_);
    // ```

    KernelAddBiasLauncher::launch<AddBiasConfig{
        .block = {128}, .grid = {grid_cover_by_axis(n, 128)}}>(y_, y_, b_);

    return output_(y_);
  }
};

using Linear1 = Linear<half, 256, 128, 64>;

KONCH_REGISTER_INFERENCE_MODULE(Linear1);

int main() {
  Linear1 linear;
  Tensor<half, 256, 64> x;
  linear.input().set(x);
  linear.forward();

  auto [y] = linear.output().value;

  // ...
}
