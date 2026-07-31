---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: Algebra.EtaleCover.ofSurjectiveEquiv
docstring: The carrier of `ofSurjective` is the presented algebra.
file: AlgebraicJacobian/Algebra/EtaleCover.lean
generated: lean
lean_status: lean_ok
title: Algebra.EtaleCover.ofSurjectiveEquiv
type: lean
updated: '2026-07-31T20:15:16'
---
noncomputable def ofSurjectiveEquiv
    (hB : Function.Surjective (PrimeSpectrum.comap (algebraMap A B)))
    {n : ℕ} (f : MvPolynomial (Fin n) A →ₐ[A] B) (hf : Function.Surjective f) :
    (ofSurjective hB f hf).Carrier ≃ₐ[A] B :=
  Ideal.quotientKerAlgEquivOfSurjective hf