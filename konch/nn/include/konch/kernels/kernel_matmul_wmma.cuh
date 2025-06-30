#ifndef _KONCH_KERNEL_MATMUL_WMMA_
#define _KONCH_KERNEL_MATMUL_WMMA_

#include "konch/kernel/kernel.cuh"
#include "konch/kernel/kernel_launcher.cuh"

#include <cstdint>
#include <mma.h>

using namespace nvcuda;

namespace konch {

struct kernel_matmul_wmma_ct_attrs : KernelAttrsCT {
  index_t wmma_m;
  index_t wmma_n;
  index_t wmma_k;
  bool wmma_colmajor_a;
  bool wmma_colmajor_b;
  bool wmma_colmajor_c;
};

__kernel__ void matmul_wmma(AccessorT& c, const AccessorT& a, const AccessorT& b) {
  // TODO: profile the kernel

  const auto [wmma_m, wmma_n, wmma_k, wmma_colmajor_a, wmma_colmajor_b, wmma_colmajor_c]
      = ct_attrs;

  using layout_a = std::conditional_t<wmma_colmajor_a, wmma::col_major, wmma::row_major>;
  using layout_b = std::conditional_t<wmma_colmajor_b, wmma::col_major, wmma::row_major>;
  using atom_t = typename AccessorT::atom_t;

  wmma::fragment<wmma::matrix_a, wmma_m, wmma_n, wmma_k, atom_t, layout_a> fa;
  wmma::fragment<wmma::matrix_b, wmma_m, wmma_n, wmma_k, atom_t, layout_b> fb;
  wmma::fragment<wmma::accumulator, wmma_m, wmma_n, wmma_k, atom_t> fc;

  wmma::fill_fragment(fc, 0.0f);

  std::uint32_t warp_x = (blockIdx.x * blockDim.x + threadIdx.x) / warpSize;
  std::uint32_t warp_y = (blockIdx.y * blockDim.y + threadIdx.y);

  std::uint32_t i = warp_y * wmma_m;
  std::uint32_t j = warp_x * wmma_n;

  std::uint32_t k = a.size(1);

  auto a_ldim = wmma_colmajor_a ? a.size(0) : a.size(1);
  auto b_ldim = wmma_colmajor_b ? b.size(0) : b.size(1);
  auto c_ldim = wmma_colmajor_c ? c.size(0) : c.size(1);

  for (std::uint32_t v = 0; v < k; v += wmma_k) {
    wmma::load_matrix_sync(fa, a.data(i, v), a_ldim);
    wmma::load_matrix_sync(fb, b.data(v, j), b_ldim);
    wmma::mma_sync(fc, fa, fb, fc);
  }

  wmma::store_matrix_sync(c.data(i, j),
      fc,
      c_ldim,
      wmma_colmajor_c ? wmma::mem_col_major : wmma::mem_row_major);
}

REGISTER_KERNEL_LAUNCHER(KernelMatmulWMMALauncher, matmul_wmma);

}  // namespace konch

#endif  // _KONCH_KERNEL_MATMUL_WMMA_
