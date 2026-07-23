---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicJacobian.TwoTerm.flat_ker_of_surjective
docstring: 'If `d : M0 → M1` is a surjection of flat modules, its kernel is flat.

  (Purity of `ker d ↪ M0` + the composite-injectivity trick; no noetherian

  hypothesis.)'
file: AlgebraicJacobian/Picard/TwoTermFiniteFree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.TwoTerm.flat_ker_of_surjective
type: lean
updated: '2026-07-16T21:14:28'
---
theorem flat_ker_of_surjective [Module.Flat A M0] [Module.Flat A M1]
    {d : M0 →ₗ[A] M1} (hd : Function.Surjective d) :
    Module.Flat A ↥(ker d) := by
  have hexact : Function.Exact (ker d).subtype d := d.exact_subtype_ker_map
  rw [Module.Flat.iff_rTensor_injective']
  intro I
  have h1 : Function.Injective (I.subtype.rTensor M0) :=
    Module.Flat.rTensor_preserves_injective_linearMap _ (Submodule.injective_subtype I)
  have h2 : Function.Injective ((ker d).subtype.lTensor ↥I) :=
    lTensor_injective_of_exact_of_flat (Submodule.injective_subtype _) hexact hd ↥I
  have hcomp : ((ker d).subtype.lTensor A).comp (I.subtype.rTensor ↥(ker d))
      = (I.subtype.rTensor M0).comp ((ker d).subtype.lTensor ↥I) := by
    rw [lTensor_comp_rTensor, rTensor_comp_lTensor]
  have h3 : Function.Injective
      ⇑(((ker d).subtype.lTensor A).comp (I.subtype.rTensor ↥(ker d))) := by
    rw [hcomp, coe_comp]
    exact h1.comp h2
  rw [coe_comp] at h3
  exact h3.of_comp