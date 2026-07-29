---
author: sync
content_type: theorem
created: '2026-07-19T21:01:15'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.hasWitnessH1Vanishing_iff_subsingleton
docstring: 'The witness predicate is the engine''s complex-form fibre condition

  `Subsingleton ((datumPair D).H1 ⊗[B] L)`, via the two-way datum dictionary

  `subsingleton_h1_tensor_iff_exists_witness` (C1, GAP-6).'
file: AlgebraicJacobian/Picard/Pic0ChartLocusFibreField.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.hasWitnessH1Vanishing_iff_subsingleton
type: lean
updated: '2026-07-29T15:31:47'
---
theorem BasicOpenCocycleDatum.hasWitnessH1Vanishing_iff_subsingleton
    (D : BasicOpenCocycleDatum C B π) (L : Type u) [Field L] [Algebra k L] [Algebra B L]
    [IsScalarTower k B L] :
    D.HasWitnessH1Vanishing L ↔ Subsingleton ((datumPair D).H1 ⊗[B] L) :=
  (D.subsingleton_h1_tensor_iff_exists_witness L).symm

/-! ## The fibre-field invariance (the gap-2 core) -/