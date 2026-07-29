---
author: sync
content_type: theorem
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.mem_chartLocus_iff
file: AlgebraicJacobian/Picard/Pic0ChartLocus.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mem_chartLocus_iff
type: lean
updated: '2026-07-29T15:31:47'
---
theorem mem_chartLocus_iff (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left) :
    t ∈ chartLocus C m Z lam ↔ IsSplitWitness C
      (picEtMap C (Over.testPoint t) (chartTwist C m Z T lam)) :=
  Iff.rfl

/-! ## The datum-layer reading

The witness clause of `IsSplitWitness` is stated on a presenting Čech class over `C_L`.
The tree's *engine-facing* predicate is stated on a `BasicOpenCocycleDatum`
(`BasicOpenCocycleDatum.HasWitnessH1Vanishing`, `Pic0ChartLocusFibreField.lean:115`), and
the two are joined by `exists_cechPicClass_eq` (every class is presented) plus
class-intrinsicity.  This is the seam CHART-U(b) crosses to reach
`datumRigidEngine_isOpen_vanishing`, so it is recorded here as a lemma of the definition
rather than left implicit in the openness proof. -/