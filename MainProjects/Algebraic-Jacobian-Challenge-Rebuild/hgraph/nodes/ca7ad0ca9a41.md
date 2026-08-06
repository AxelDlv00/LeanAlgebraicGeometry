---
author: sync
content_type: theorem
created: '2026-08-06T17:11:06'
decl: AlgebraicGeometry.residueDeg_one_of_graphPoint
docstring: The graph point of a field-valued point has residue degree one.
file: AlgebraicJacobian/Picard/Pic0SepClosedCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.residueDeg_one_of_graphPoint
type: lean
updated: '2026-08-07T05:01:57'
---
theorem residueDeg_one_of_graphPoint
    {k K : Type u} [Field k] [Field K] [Algebra k K]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    (t : overSpec k K ⟶ C) :
    (C ⊗ overSpec k K).left.residueDeg K (Over.graphPoint C t) = 1 := by
  exact residueDeg_one_of_section
    (X := Over.mk (snd C (overSpec k K)).left)
    (e := (Over.sectionOfPoint t).left)
    (by
      exact congrArg (fun q : overSpec k K ⟶ overSpec k K => q.left)
        (Over.sectionOfPoint_snd t))
    (by
      change (Over.sectionOfPoint t).left.base (IsLocalRing.closedPoint K) =
        (Over.sectionOfPoint t).left.base default
      exact congrArg (Over.sectionOfPoint t).left.base
        (Subsingleton.elim _ _))