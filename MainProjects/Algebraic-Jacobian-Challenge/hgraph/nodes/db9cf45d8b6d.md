---
author: sync
content_type: definition
created: '2026-07-30T13:03:22'
decl: AlgebraicGeometry.ProjectiveSpace.affineChart.incl
docstring: The inclusion of the standard chart into relative projective space.
file: AlgebraicJacobian/Picard/ProjectiveSpaceAffineChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.affineChart.incl
type: lean
updated: '2026-07-30T13:03:22'
---
def incl : affineChart n S ⟶ ℙ(Option n; S) :=
  pullback.fst (toProjInt (Option n) S)
    (Proj.awayι P[n] (X none) (X_none_mem_deg_one n) Nat.zero_lt_one)

instance : IsOpenImmersion (incl n S) := by
  dsimp [incl]
  exact MorphismProperty.pullback_fst _ _
    (Proj.instIsOpenImmersionAwayι P[n] (X none)
      (X_none_mem_deg_one n) Nat.zero_lt_one)

/-- The chart inclusion followed by the integral-model projection is the
other pullback projection followed by `Proj.awayι`. -/
@[reassoc]