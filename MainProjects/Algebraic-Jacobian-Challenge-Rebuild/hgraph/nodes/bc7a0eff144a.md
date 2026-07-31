---
author: sync
content_type: theorem
created: '2026-07-30T10:29:03'
decl: AlgebraicGeometry.ProbeP4R6d.probeSplitEpi
docstring: 'A: f is a SPLIT EPI when restrictChart f V is an iso.'
file: scratch_p4r6/probe8.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProbeP4R6d.probeSplitEpi
type: lean
updated: '2026-07-31T20:38:24'
---
theorem probeSplitEpi {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (V : X.Opens) [IsIso (restrictChart f V)] :
    ∃ s : (pic0SigmaSheaf C).1 ⟶ yoneda.obj X, s ≫ f = 𝟙 _ := by
  refine ⟨inv (restrictChart f V) ≫ yoneda.map V.ι, ?_⟩
  rw [Category.assoc]
  exact IsIso.inv_hom_id (restrictChart f V)