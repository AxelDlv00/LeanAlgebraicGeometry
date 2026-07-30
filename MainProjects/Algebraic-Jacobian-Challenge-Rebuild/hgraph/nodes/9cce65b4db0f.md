---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.PointedCover.BasicRefinement.span_eq_top
docstring: The sections of a basic refinement span the unit ideal.
file: AlgebraicJacobian/Picard/PicAffineCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PointedCover.BasicRefinement.span_eq_top
type: lean
updated: '2026-07-30T15:46:06'
---
theorem span_eq_top [IsAffine X] : Ideal.span (Set.range P.r) = ⊤ := by
  rw [← (isAffineOpen_top X).iSup_basicOpen_eq_self_iff]
  rw [iSup_range' (fun f ↦ X.basicOpen f) P.r]
  exact P.iSup_eq