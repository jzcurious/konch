#ifndef _KONCH_KERNEL_MATMUL_WMMA_
#define _KONCH_KERNEL_MATMUL_WMMA_

#include <konch/core.cuh>

#include <cstdint>
#include <mma.h>

using namespace nvcuda;

struct MatmulWMMAConfig {
  /* This class is intentionally defined outside the 'konch' namespace. This is required
   * for proper cudafe stub generation. */

  dim3 block;
  dim3 grid;

  cudaStream_t stream = 0;
  std::size_t shmem = 0;
  std::uint16_t wmma_m = 16;
  std::uint16_t wmma_n = 16;
  std::uint16_t wmma_k = 16;
  bool wmma_colmajor_a = false;
  bool wmma_colmajor_b = false;
  bool wmma_colmajor_c = false;
};

namespace konch {

__kernel__ void matmul_wmma(AutoAccessor c,
    const AutoAccessor a,
    const AutoAccessor b) {  // TODO: shape constraint

  using layout_a
      = std::conditional_t<config.wmma_colmajor_a, wmma::col_major, wmma::row_major>;

  using layout_b
      = std::conditional_t<config.wmma_colmajor_b, wmma::col_major, wmma::row_major>;

  using atom_t = typename decltype(c)::atom_t;

  wmma::fragment<wmma::matrix_a,
      config.wmma_m,
      config.wmma_n,
      config.wmma_k,
      atom_t,
      layout_a>
      fa;

  wmma::fragment<wmma::matrix_b,
      config.wmma_m,
      config.wmma_n,
      config.wmma_k,
      atom_t,
      layout_b>
      fb;

  wmma::fragment<wmma::accumulator, config.wmma_m, config.wmma_n, config.wmma_k, atom_t>
      fc;

  wmma::fill_fragment(fc, 0.0f);

  std::uint32_t warp_x = (blockIdx.x * blockDim.x + threadIdx.x) / warpSize;
  std::uint32_t warp_y = (blockIdx.y * blockDim.y + threadIdx.y);

  std::uint32_t i = warp_y * config.wmma_m;
  std::uint32_t j = warp_x * config.wmma_n;

  std::uint32_t k = a.view.size(1);

  auto a_ldim = config.wmma_colmajor_a ? a.view.size(0) : a.view.size(1);
  auto b_ldim = config.wmma_colmajor_b ? b.view.size(0) : b.view.size(1);
  auto c_ldim = config.wmma_colmajor_c ? c.view.size(0) : c.view.size(1);

  for (std::uint32_t v = 0; v < k; v += config.wmma_k) {
    wmma::load_matrix_sync(fa, a.data(i, v), a_ldim);
    wmma::load_matrix_sync(fb, b.data(v, j), b_ldim);
    wmma::mma_sync(fc, fa, fb, fc);
  }

  wmma::store_matrix_sync(c.data(i, j),
      fc,
      c_ldim,
      config.wmma_colmajor_c ? wmma::mem_col_major : wmma::mem_row_major);
}

KONCH_REGISTER_KERNEL_LAUNCHER(KernelMatmulWMMALauncher, matmul_wmma, MatmulWMMAConfig);

}  // namespace konch

#endif  // _KONCH_KERNEL_MATMUL_WMMA_
