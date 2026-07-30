---
author: sync
content_type: theorem
created: '2026-07-25T22:02:28'
decl: AlgebraicGeometry.DivisorAdaptation.not_forall_noLeak_of_not_isClosed_chart₀
docstring: '**The obstruction.** If the chart-0 trace of the system is not closed
  in the relative

  curve, then no adaptation of that system satisfies the assembler''s no-leak clause.'
file: AlgebraicJacobian/Picard/DivSchemeCertZarChartTrace.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.not_forall_noLeak_of_not_isClosed_chart₀
type: lean
updated: '2026-07-30T15:28:06'
---
theorem not_forall_noLeak_of_not_isClosed_chart₀
    (hnc : ¬ IsClosed (d.supportLocus
      ∩ ((relCover C R (fiberTwoCover π)).V₀ : Set (relCurve C R)))) :
    ¬ ∀ (j : A.index) (s : Spec (.of R)),
      ((relCurve C R) ↘ Spec (.of R)).base ⁻¹' {s}
          ∩ closure (d.supportLocus ∩ (A.pieces j : Set (relCurve C R))) ⊆
        (A.pieces j : Set (relCurve C R)) :=
  fun h => hnc (A.isClosed_supportLocus_inter_chart_of_forall_noLeak h).1