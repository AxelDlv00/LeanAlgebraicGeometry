---
author: sync
content_type: theorem
created: '2026-07-30T17:14:50'
decl: AlgebraicGeometry.no_proper_open_abelSigmaChartZero
docstring: '**And every open is `⊥` or `⊤`, so there is nothing else to try.**


  The representing object of the degree-`0` representation is `Over.mk (𝟙 (Spec k))`,
  a one-point

  space.  Combined with the previous theorem and `not_coverageContainment_bot`, the
  coverage half of

  the coupled assembly is refuted at **every** open of the chart source at this parameter
  — not at

  "every proper open, leaving `⊤`", because `⊤` is where the previous theorem''s hypothesis
  `V ≠ ⊤`

  fails and `restrictChart … ⊤` returns the unrestricted problem.


  Stated as the disjunction rather than as a further refutation, because that is what
  is proved: the

  interval has two points, one of them refuted here and the other refuted by

  `not_coverageContainment_bot`.  The conclusion for a lane is that **parameter `0`
  is not a route to

  representability through this atlas**, which is worth a theorem precisely because
  the `rep` slot

  now HAS a producer there and the natural next move would be to try it.'
file: AlgebraicJacobian/Picard/Pic0ChartMonoUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.no_proper_open_abelSigmaChartZero
type: lean
updated: '2026-07-30T17:14:50'
---
theorem no_proper_open_abelSigmaChartZero
    (V : (Over.mk (𝟙 (Spec (CommRingCat.of k)))).left.Opens) :
    V = ⊥ ∨ V = ⊤ :=
  opens_eq_bot_or_top_of_terminalRep (k := k) V