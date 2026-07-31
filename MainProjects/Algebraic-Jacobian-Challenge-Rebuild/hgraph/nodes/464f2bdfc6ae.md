---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.degAt_thetaFamily
docstring: '**The degree of the θ-family at every field point (DAT-5.2)**: `degAt
  (θ_T) t` equals

  `classDeg k L₀`, the base-field-invariant θ-degree `d₁`.  Route: naturality reduces
  the

  field point at `T` to the identity point at `overSpec k K`, and DAT-4''s

  `degAt_eq_classDeg_of_affineEquiv_eq_unit_baseChange` reads off `classDeg k L₀`.'
file: AlgebraicJacobian/Picard/ThetaShift.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.degAt_thetaFamily
type: lean
updated: '2026-07-31T20:15:28'
---
theorem degAt_thetaFamily (L₀ : (C ⊗ overSpec k k).left.CechPic)
    {T : Over (Spec (.of k))} {K : Type u} [Field K] [Algebra k K]
    (t : overSpec k K ⟶ T) :
    degAt (thetaFamily C L₀ T) t = classDeg k L₀ := by
  have key : degAt (thetaFamily C L₀ (overSpec k K)) (Over.overSpecMap (AlgHom.id k K))
      = classDeg k L₀ :=
    degAt_eq_classDeg_of_affineEquiv_eq_unit_baseChange (AlgHom.id k K)
      (thetaFamily C L₀ (overSpec k K)) L₀ (thetaFamily_overSpec_affineEquiv C L₀ K)
  rw [Over.overSpecMap_id] at key
  rw [← key, ← thetaFamily_natural C L₀ t, degAt_picEtMap, Category.id_comp]

variable (C) in