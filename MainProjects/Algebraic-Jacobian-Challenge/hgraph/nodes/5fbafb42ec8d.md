---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.SectionCechModule.comp_succAbove_one
docstring: 'Deleting the index `1` from a pair multi-index `σ : Fin 2 → α` leaves
  the

  singleton multi-index at its first entry `σ 0`.'
file: AlgebraicJacobian/Cohomology/CechCoboundarySplitting.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.SectionCechModule.comp_succAbove_one
type: lean
updated: '2026-07-16T21:14:26'
---
lemma comp_succAbove_one {α : Type*} (σ : Fin 2 → α) :
    σ ∘ (1 : Fin 2).succAbove = fun _ : Fin 1 => σ 0 := by
  funext k
  have hk : k = 0 := Subsingleton.elim k 0
  subst hk
  rfl

variable {R : Type u} [CommRing R] (s : ι → R)
variable (M : Type u) [AddCommGroup M] [Module R M]