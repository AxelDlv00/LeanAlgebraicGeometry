---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.ProjectiveSpace.map_toProjInt
file: AlgebraicJacobian/Picard/ProjectiveSpace.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.map_toProjInt
type: lean
updated: '2026-07-16T21:14:27'
---
lemma map_toProjInt (f : S ⟶ T) : map n f ≫ toProjInt n T = toProjInt n S := by
  rw [toProjInt_eq_snd, toProjInt_eq_snd]
  exact (pullback.lift_snd _ _ _).trans (Category.comp_id _)

@[simp]