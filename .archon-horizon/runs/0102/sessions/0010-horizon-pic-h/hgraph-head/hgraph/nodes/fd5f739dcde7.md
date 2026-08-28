---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.fst_graphPoint
docstring: The first projection of the graph point is the image point of `t`.
file: AlgebraicJacobian/Curve/GraphFibre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.fst_graphPoint
type: lean
updated: '2026-08-01T09:44:10'
---
lemma fst_graphPoint (t : overSpec k K ⟶ C) :
    (fst C (overSpec k K)).left.base (graphPoint C t) = t.left.base default := by
  have h : (sectionOfPoint t).left ≫ (fst C (overSpec k K)).left = t.left := by
    rw [← Over.comp_left, sectionOfPoint_fst]
  calc (fst C (overSpec k K)).left.base ((sectionOfPoint t).left.base default)
      = ((sectionOfPoint t).left ≫ (fst C (overSpec k K)).left).base default := rfl
    _ = t.left.base default := by rw [h]