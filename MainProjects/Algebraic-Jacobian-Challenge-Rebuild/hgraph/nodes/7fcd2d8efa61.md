---
author: sync
content_type: theorem
created: '2026-07-30T11:09:50'
decl: AlgebraicGeometry.A_noDominant
file: scratch_p4r6_audit/p09_binders.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.A_noDominant
type: lean
updated: '2026-07-30T23:41:27'
---
theorem A_noDominant {X : Scheme.{u}} [IsReduced X] [X.IsSeparated]
    (V : X.Opens)
    (r : X ⟶ (V : Scheme.{u})) (hr : V.ι ≫ r = 𝟙 _) :
    V = ⊤ := by
  haveI : IsIso (V.ι) := by
    refine ⟨r, hr, ?_⟩
    refine ext_of_isDominant (X := X) (Y := X) (W := (V : Scheme.{u})) (V.ι) ?_
    rw [← Category.assoc, hr, Category.id_comp, Category.comp_id]
  have hsurj : Function.Surjective (V.ι).base :=
    (TopCat.homeoOfIso (asIso (Scheme.forgetToTop.map (V.ι)))).surjective
  refine top_le_iff.mp fun x _ => ?_
  obtain ⟨y, rfl⟩ := hsurj x
  exact y.2