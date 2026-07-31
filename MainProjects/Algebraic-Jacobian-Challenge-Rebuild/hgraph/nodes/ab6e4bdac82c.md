---
author: sync
content_type: theorem
created: '2026-07-30T11:09:50'
decl: AlgebraicGeometry.retract2
docstring: V2.ι IS SPLIT MONO, with NO density / IsDominant hypothesis anywhere.
file: scratch_p4r6_audit/p17_coprod_ce4.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.retract2
type: lean
updated: '2026-07-31T15:03:38'
---
theorem retract2 : (V2 R).ι ≫ r2 R = 𝟙 _ := by
  rw [← cancel_epi ((coprod.inl : Spec R ⟶ X2 R).isoOpensRange).hom]
  simp only [r2, Scheme.Hom.isoOpensRange_hom_ι_assoc, coprod.inl_desc, Category.comp_id]