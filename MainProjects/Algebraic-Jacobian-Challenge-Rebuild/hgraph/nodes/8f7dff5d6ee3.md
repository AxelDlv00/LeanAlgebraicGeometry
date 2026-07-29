---
author: sync
content_type: theorem
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.finrank_h0_baseField
docstring: 'The degree-zero scalar identity: the `K`-dimension of `H⁰(C_K, 𝒪)` equals
  the

  `k`-dimension of `H⁰(C, 𝒪)`.'
file: AlgebraicJacobian/Cohomology/H1BaseFieldInvariance.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.finrank_h0_baseField
type: lean
updated: '2026-07-29T15:31:35'
---
theorem finrank_h0_baseField :
    letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
    Module.finrank K (Sheaf.HModule ((C ⊗ overSpec k K).left.moduleKSheaf K) 0) =
      Module.finrank k (Sheaf.HModule (C.left.moduleKSheaf k) 0) := by
  letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
  rw [← (h0BaseFieldEquiv C K).finrank_eq]
  exact Module.finrank_baseChange