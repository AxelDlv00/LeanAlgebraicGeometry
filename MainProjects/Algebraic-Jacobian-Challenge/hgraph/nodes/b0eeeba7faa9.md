---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: Module.MatrixPresentation.congr
docstring: 'Transport of a matrix presentation along a linear equivalence of the

  presented module; the relation matrix — hence the entry ideal — is

  unchanged.'
file: AlgebraicJacobian/Picard/EntryIdealStratum.lean
generated: lean
lean_status: lean_ok
title: Module.MatrixPresentation.congr
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def congr (P : MatrixPresentation R M e m) (σ : M ≃ₗ[R] N) :
    MatrixPresentation R N e m where
  relMatrix := P.relMatrix
  proj := σ.toLinearMap ∘ₗ P.proj
  surjective_proj := σ.surjective.comp P.surjective_proj
  exact_mulVecLin_proj := fun y => by
    simp only [LinearMap.comp_apply, LinearEquiv.coe_coe,
      LinearEquiv.map_eq_zero_iff]
    exact P.exact_mulVecLin_proj y