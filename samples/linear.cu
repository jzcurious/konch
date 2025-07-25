#include <konch/kernel_add_bias.cuh>
#include <konch/kernel_matmul_wmma.cuh>

using namespace konch;

struct kernel_matmul_wmma_config_t {
  dim3 grid;
  dim3 block = {32, 1};
  std::size_t shmem = 0;
  // cudaStream_t stream;

  index_t wmma_m = 16;
  index_t wmma_n = 16;
  index_t wmma_k = 16;
  bool wmma_colmajor_a = false;
  bool wmma_colmajor_b = false;
  bool wmma_colmajor_c = false;

  // constexpr kernel_matmul_wmma_config_t(std::size_t m, std::size_t n) // TODO: fix it
  //     : grid{grid_cover_by_axis(n, 16), grid_cover_by_axis(m, 16)} {}
};

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

    constexpr auto config = kernel_matmul_wmma_config_t{};

    KernelMatmulWMMALauncher::launch<config>(
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
