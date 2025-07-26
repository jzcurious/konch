#include <konch/core.cuh>
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

    KernelMatmulWMMALauncher::launch<MatmulWMMAKernelConfigDefault>(
        y_.accessor(), x->accessor(), w_.accessor());  // TODO: store config to launcher

    // KernelMatmulWMMALauncher::launch<kernel_matmul_wmma_config_t(m, n)>(
    //     y_.accessor(), x->accessor(), w_.accessor());  // TODO: store config to
    //     launcher

    // KernelMatmulWMMALauncher::launch<kernel_matmul_wmma_config_t(m, n)>(
    //     y_, *x, w_);  // TODO: store config to launcher

    return output_(y_);
  }
};

using Linear1 = Linear<half, 256, 128, 64>;

static_assert(InferenceModuleKind<Linear1>);

int main() {
  Linear1 linear;
  Tensor<half, 256, 64> x;
  linear.input().set(x);
  linear.forward();

  // auto [y] = linear.output().value;
}
