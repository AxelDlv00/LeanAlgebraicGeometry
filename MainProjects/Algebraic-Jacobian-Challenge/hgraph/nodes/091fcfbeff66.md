---
author: sync
content_type: instance
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.QuotFamily.setoid
docstring: The equivalence-of-families setoid.
file: AlgebraicJacobian/Picard/QuotFunctorDef.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.QuotFamily.setoid
type: lean
updated: '2026-07-24T03:02:11'
---
instance setoid (π : X ⟶ S) [LocallyOfFiniteType π] (L E : X.Modules)
    (Φ : Polynomial ℚ) (T : Over S) : Setoid (QuotFamily π L E Φ T) where
  r := Rel
  iseqv := ⟨rel_refl, rel_symm, rel_trans⟩