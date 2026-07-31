---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Scheme.CurveDivisor.deg_mono
docstring: '**Degree is monotone** on the divisor lattice.'
file: AlgebraicJacobian/RiemannRoch/SectionSpaces.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.CurveDivisor.deg_mono
type: lean
updated: '2026-07-31T20:15:29'
---
lemma Scheme.CurveDivisor.deg_mono {D D' : X.CurveDivisor} (h : D ≤ D') :
    CurveDivisor.deg K D ≤ CurveDivisor.deg K D' := by
  have hE : 0 ≤ D' - D := by
    refine Finsupp.le_def.mpr (fun p => ?_)
    have hp : toFinsupp D p ≤ toFinsupp D' p := Finsupp.le_def.mp h p
    change (0 : ℤ) ≤ toFinsupp (D' - D) p
    have hsub : toFinsupp (D' - D) p = toFinsupp D' p - toFinsupp D p :=
      Finsupp.sub_apply _ _ _
    omega
  have hnn := Scheme.CurveDivisor.deg_nonneg K hE
  rw [Scheme.CurveDivisor.deg_sub' K] at hnn
  linarith