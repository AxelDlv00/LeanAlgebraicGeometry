---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.braiding_canonical_self_eq_id_of_isInvertible
docstring: '**Canonical self-braiding of an invertible sheaf is the identity** (named
  sub-brick): the

  *canonical* symmetric-monoidal braiding `β_ L L` of `X.Modules` is the identity
  on `L ⊗ L`.  This

  is the canonical-level image of the hand-built PRIMARY `tensorBraiding_self_eq_id_of_isInvertible`,

  read off through the bridge `tensorBraiding_eq`.  Project-local; the β-collapse
  input to the succ

  case of `tensorPowAdd_succ_left_braided` and the succ case of `tensorPowAdd_comm`.'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.braiding_canonical_self_eq_id_of_isInvertible
type: lean
updated: '2026-07-24T03:02:12'
---
private lemma braiding_canonical_self_eq_id_of_isInvertible (L : X.Modules) [IsInvertibleGr L] :
    (β_ L L).hom = 𝟙 (L ⊗ L) := by
  have h := congrArg Iso.hom (tensorBraiding_eq L L)
  rw [tensorBraiding_self_eq_id_of_isInvertible] at h
  simp only [Iso.refl_hom, Iso.trans_hom, Iso.symm_hom] at h
  -- `h : 𝟙 = (tensorObjIso L L).inv ≫ (β_ L L).hom ≫ (tensorObjIso L L).hom`.
  rw [eq_comm, Iso.inv_comp_eq] at h
  -- `h : (β_ L L).hom ≫ (tensorObjIso L L).hom = (tensorObjIso L L).hom`.
  exact (cancel_mono (tensorObjIso L L).hom).mp (h.trans (Category.id_comp _).symm)