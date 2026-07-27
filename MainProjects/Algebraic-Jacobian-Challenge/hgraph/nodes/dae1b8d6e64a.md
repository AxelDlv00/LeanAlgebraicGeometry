---
author: sync
content_type: lemma
created: '2026-07-24T17:02:56'
decl: RingTheory.Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator
docstring: '**Matrix-collapse on Ext.** For an R-linear map `A : R^m →ₗ R^n` whose
  every

  matrix entry `A (Pi.single j 1) i` lies in `Ann_R N`, the postcomposition map

  `Ext^p(N, R^m) → Ext^p(N, R^n)` induced by `mk₀ (ofHom A)` is the zero map.


  Proof: write `A = ∑_{(i,j)} A_{i,j} • E_{i,j}` via `linearMap_finFunR_matrix_decomp`.

  Push through `ofHom`, `mk₀`, and `Ext.comp` using `ofHom_sum / mk₀_sum / comp_sum`

  plus `ofHom_smul / mk₀_smul / comp_smul`. Each summand becomes

  `A_{i,j} • (e.comp (mk₀ (ofHom (elemMap _ _ i j))))`, where the scalar `A_{i,j}`

  lies in `Ann_R N`. The existing `ext_smul_eq_zero_of_mem_annihilator` (Stacks

  00LP fragment) makes each such scalar action zero. Hence the total sum is zero.'
file: AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
generated: lean
lean_status: lean_ok
title: RingTheory.Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator
type: lean
updated: '2026-07-27T12:05:09'
---
