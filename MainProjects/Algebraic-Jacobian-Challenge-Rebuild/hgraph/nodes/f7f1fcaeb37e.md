---
author: sync
content_type: theorem
created: '2026-07-28T17:25:27'
decl: AlgebraicGeometry.chartTwist_chartValue
docstring: '**`chartTwist` inverts `chartValue`''s twist** — the sign check, as a
  theorem rather than a

  docstring claim.


  Applying `chartTwist` to a chart value returns the Abel class it came from.  This
  is the

  statement that was FALSE of the earlier definition (which returned

  `abelDiv · Σ² · (θᵐ)⁻²`), and it is why the direction is now pinned by the kernel:
  any future

  edit to `chartTwist` that breaks the inversion breaks this lemma.


  Recorded per issue I-0514.  A degree ledger alone does not catch a sign error —
  the wrong-signed

  ledger was internally consistent — but an inversion law does.'
file: AlgebraicJacobian/Picard/Pic0ChartLocus.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.chartTwist_chartValue
type: lean
updated: '2026-07-31T20:15:27'
---
theorem chartTwist_chartValue {n : ℕ} (m : ℕ)
    (Z : (C ⊗ overSpec k k).left.CurveDivisor) (T : Over (Spec (.of k)))
    (s : divFamZar C π n T) :
    chartTwist C m Z T (chartValue C π n m Z T s) = abelDiv C π n T s := by
  rw [chartTwist, chartValue]
  group

/-! ## CHART-U(a): the locus -/

variable (C) in