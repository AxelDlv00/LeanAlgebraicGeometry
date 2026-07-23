---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.moduleCat_braiding_self_hom_eq_id
docstring: 'On an **invertible** module the `ModuleCat` self-braiding is the identity,
  since

  `TensorProduct.comm` is the identity (`Module.Invertible.tensorProductComm_eq_refl`).  The

  invertibility is taken as an explicit argument so the project''s `Γ(X,U)`-vs-`R.obj
  U`

  ring-spelling is reconciled by definitional unification rather than instance search.

  Project-local helper.'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.moduleCat_braiding_self_hom_eq_id
type: lean
updated: '2026-07-16T21:14:28'
---
private lemma moduleCat_braiding_self_hom_eq_id {R : Type u} [CommRing R]
    (M : ModuleCat.{u} R) (hM : Module.Invertible R M) :
    (β_ M M).hom = 𝟙 (M ⊗ M) := by
  haveI := hM
  rw [moduleCat_braiding_hom_eq_comm, Module.Invertible.tensorProductComm_eq_refl]
  rfl