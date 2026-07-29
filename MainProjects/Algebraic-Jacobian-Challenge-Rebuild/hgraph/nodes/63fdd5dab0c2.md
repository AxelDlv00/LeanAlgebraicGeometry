---
author: sync
content_type: theorem
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.AffAdaptation.supportLeak_eq_empty_of_subset_or_disjoint
docstring: '**Swallow or miss gives no-leak at that piece.**  Swallowing: the trace
  is the whole

  support, closed by `isClosed_supportLocus`.  Missing: the trace is empty.  No fibre,
  no

  tube, no idempotent, and — the point — no chart.


  Note the signature: this does not mention the adaptation at all, only the piece.  That
  is

  the sharpest form of I-0492 clause 3 — swallow-or-miss is a statement about an OPEN
  SET.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffPerPiece.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.supportLeak_eq_empty_of_subset_or_disjoint
type: lean
updated: '2026-07-29T15:26:23'
---
theorem supportLeak_eq_empty_of_subset_or_disjoint (U : (relCurve C R).Opens)
    (h : d.supportLocus ⊆ (U : Set (relCurve C R))
      ∨ Disjoint d.supportLocus (U : Set (relCurve C R))) :
    d.supportLeak U = ∅ := by
  refine (d.isClosed_supportLocus_inter_iff_supportLeak_eq_empty U).mp ?_
  rcases h with hsub | hdisj
  · rw [Set.inter_eq_left.mpr hsub]
    exact d.isClosed_supportLocus
  · rw [Set.disjoint_iff_inter_eq_empty.mp hdisj]
    exact isClosed_empty