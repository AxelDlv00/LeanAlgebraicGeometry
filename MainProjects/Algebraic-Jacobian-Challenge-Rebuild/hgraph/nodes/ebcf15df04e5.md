---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: Algebra.EtaleCover.selfEquiv
docstring: The carrier of the trivial cover is the base ring.
file: AlgebraicJacobian/Algebra/EtaleCover.lean
generated: lean
lean_status: lean_ok
title: Algebra.EtaleCover.selfEquiv
type: lean
updated: '2026-07-29T15:31:34'
---
noncomputable def selfEquiv (A : Type u) [CommRing A] : (self A).Carrier ≃ₐ[A] A :=
  ofEquiv A _