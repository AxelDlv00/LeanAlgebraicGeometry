---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: TruncExpCech.mapAlgHom
docstring: 'The functorial dual-number map `k[ε] → A[ε]` over the algebra map `k →
  A`, as a

  `k`-algebra homomorphism (`mapRingHom` with its `algebraMap`-compatibility, which
  holds

  componentwise).'
file: AlgebraicJacobian/Tangent/DualNumberBaseChange.lean
generated: lean
lean_status: lean_ok
stale: true
title: TruncExpCech.mapAlgHom
type: lean
updated: '2026-07-29T15:26:37'
---
def mapAlgHom : DualNumber k →ₐ[k] DualNumber A :=
  { mapRingHom (algebraMap k A) with
    commutes' := fun c => by
      refine TrivSqZeroExt.ext ?_ ?_ <;>
        simp [TrivSqZeroExt.algebraMap_eq_inl' k A, TrivSqZeroExt.algebraMap_eq_inl] }

@[simp]