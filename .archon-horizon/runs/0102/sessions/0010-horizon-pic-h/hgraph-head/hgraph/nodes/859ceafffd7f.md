---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.whiskerLeft_comp_graphLift
docstring: '**The graph-lift whisker square** (base-change geometry): whiskering the
  graph lift of a

  point `t : T ⟶ C` by `C ◁ g` is the graph lift of the restricted point `g ≫ t`.  Proved
  by

  the cartesian-product universal property (`hom_ext`), the exemplar being

  `Over.sectionOfPoint_naturality` (`Picard/Rigidification.lean`).'
file: AlgebraicJacobian/Curve/GraphDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.whiskerLeft_comp_graphLift
type: lean
updated: '2026-08-01T09:44:10'
---
lemma whiskerLeft_comp_graphLift {T' : Over (Spec (.of k))} (g : T' ⟶ T) (t : T ⟶ C) :
    (C ◁ g) ≫ lift (fst C T) (snd C T ≫ t)
      = lift (fst C T') (snd C T' ≫ g ≫ t) := by
  refine hom_ext _ _ ?_ ?_
  · rw [Category.assoc, lift_fst, whiskerLeft_fst, lift_fst]
  · rw [Category.assoc, lift_snd, ← Category.assoc, whiskerLeft_snd, Category.assoc, lift_snd]

/-! ## The regularity discharge (the brick's real content) -/