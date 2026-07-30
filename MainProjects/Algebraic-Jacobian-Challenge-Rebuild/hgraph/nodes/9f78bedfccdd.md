---
author: sync
content_type: theorem
created: '2026-07-30T11:09:50'
decl: AlgebraicGeometry.exists_retraction_of_isChartUniv
docstring: '**The retraction at the Abel chart**: the seam''s two antecedents at `V`
  make `V` a retract

  of the *divisor scheme* `D.left`.


  This is the form in which the constraint should be read against the `divrep` lane:
  whatever

  representing object `rep` supplies, a working `V` is a retract of it.'
file: AlgebraicJacobian/Picard/Pic0ChartSeamCollapse.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.exists_retraction_of_isChartUniv
type: lean
updated: '2026-07-30T15:28:02'
---
theorem exists_retraction_of_isChartUniv {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (V : D.left.Opens) (huniv : IsChartUniv C π n rep m Z hdeg V)
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (restrictChart (abelSigmaChart C π n rep m Z hdeg) V)) :
    ∃ r : D.left ⟶ (V : Scheme.{u}), V.ι ≫ r = 𝟙 _ :=
  exists_retraction_of_seam C _ V huniv hcov