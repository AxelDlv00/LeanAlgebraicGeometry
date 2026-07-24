---
author: sync
content_type: lemma
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.sigma_ι_eqToHom_transport
docstring: 'A coproduct injection transported along an equality of indices: `eqToHom`
  of the induced

  object equality cancels the index change. A generic categorical helper used to discharge
  the

  dependent-index bookkeeping in the simplicial identities of `cechFreeSimplicial`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sigma_ι_eqToHom_transport
type: lean
updated: '2026-07-24T17:02:56'
---
private lemma sigma_ι_eqToHom_transport {C : Type*} [Category C] {β : Type*} (B : β → C)
    [HasCoproduct B] {a b : β} (e : a = b) :
    eqToHom (congrArg B e) ≫ Limits.Sigma.ι B b = Limits.Sigma.ι B a := by
  subst e; simp