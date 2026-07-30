---
author: sync
content_type: theorem
created: '2026-07-30T00:56:03'
decl: AlgebraicGeometry.sigmaDesc_restrictChart_le
docstring: '**The atlas-level factorisation**: `Sigma.desc` of the smaller restricted
  family factors

  through `Sigma.desc` of the larger one, through the coproduct of the open inclusions.


  Stated separately from `restrictChart_le` because the seam''s antecedent 2 is an
  instance on

  `Sigma.desc`, not on the individual charts, and the coproduct step is where a spelling-level

  argument stops (compare `not_coverageContainment_bot`, which constrains the `hcov`
  spelling

  and not the binder).'
file: AlgebraicJacobian/Picard/Pic0ChartVMonotone.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.sigmaDesc_restrictChart_le
type: lean
updated: '2026-07-30T15:28:03'
---
theorem sigmaDesc_restrictChart_le {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (U V : ∀ i, (X i).Opens) (e : ∀ i, U i ≤ V i) :
    (Sigma.desc fun i => restrictChart (f i) (U i))
      = (Limits.Sigma.map fun i => yoneda.map ((X i).homOfLE (e i)))
        ≫ Sigma.desc fun i => restrictChart (f i) (V i) := by
  refine Limits.Sigma.hom_ext _ _ fun i => ?_
  rw [Limits.Sigma.ι_desc, Limits.Sigma.ι_map_assoc, Limits.Sigma.ι_desc]
  exact restrictChart_le (C := C) (f i) (e i)