---
author: sync
content_type: definition
created: '2026-07-17T23:01:28'
decl: AlgebraicGeometry.eCurve
docstring: 'The iso-grade curve transport at the tower composite: `pic0PullbackNat`
  of the frozen

  `baseChange.compIso`.'
file: AlgebraicJacobian/Picard/Pic0ThetaCocycle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.eCurve
type: lean
updated: '2026-08-01T09:44:16'
---
noncomputable def eCurve :
    pic0Functor ((baseChange k M).obj C)
      ≅ pic0Functor ((baseChange k L ⋙ baseChange L M).obj C) where
  hom := pic0PullbackNat ((baseChange.compIso k L M).app C).inv
  inv := pic0PullbackNat ((baseChange.compIso k L M).app C).hom
  hom_inv_id := by rw [← pic0PullbackNat_comp, Iso.hom_inv_id, pic0PullbackNat_id]
  inv_hom_id := by rw [← pic0PullbackNat_comp, Iso.inv_hom_id, pic0PullbackNat_id]