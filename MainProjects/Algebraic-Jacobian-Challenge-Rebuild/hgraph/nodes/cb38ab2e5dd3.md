---
author: sync
content_type: theorem
created: '2026-07-25T22:02:28'
decl: AlgebraicGeometry.DivisorAdaptation.isClosed_supportLocus_inter_chart₀_of_forall_supportLeak_eq_empty
docstring: '**No-leak at every chart-0 piece forces the chart-0 trace closed.** The
  trace of the

  whole pinned chart is the finite union of the piece traces, each of which is closed
  exactly

  when nothing leaks out of it.'
file: AlgebraicJacobian/Picard/DivSchemeCertZarChartTrace.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.isClosed_supportLocus_inter_chart₀_of_forall_supportLeak_eq_empty
type: lean
updated: '2026-07-29T15:31:39'
---
theorem isClosed_supportLocus_inter_chart₀_of_forall_supportLeak_eq_empty
    (h : ∀ j : Fin A.m₀, d.supportLeak (A.pieces (Sum.inl j)) = ∅) :
    IsClosed (d.supportLocus
      ∩ ((relCover C R (fiberTwoCover π)).V₀ : Set (relCurve C R))) := by
  rw [A.supportLocus_inter_chart₀_eq_iUnion]
  exact isClosed_iUnion_of_finite fun j =>
    (d.isClosed_supportLocus_inter_iff_supportLeak_eq_empty _).mpr (h j)