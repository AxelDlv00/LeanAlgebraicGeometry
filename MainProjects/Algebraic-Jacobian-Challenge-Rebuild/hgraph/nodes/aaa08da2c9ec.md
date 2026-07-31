---
author: sync
content_type: instance
created: '2026-07-24T17:02:48'
decl: AlgebraicGeometry.Grassmannian.isClosedImmersion_vanishingLocusι
docstring: 'The vanishing locus is a **closed subscheme** of `Spec R`:

  `IsClosedImmersion.spec_of_surjective` applied to the quotient map.'
file: AlgebraicJacobian/Picard/VanishingLocus.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Grassmannian.isClosedImmersion_vanishingLocusι
type: lean
updated: '2026-07-31T20:14:49'
---
instance isClosedImmersion_vanishingLocusι (φ : M →ₗ[R] N) :
    IsClosedImmersion (vanishingLocusι φ) :=
  IsClosedImmersion.spec_of_surjective
    (CommRingCat.ofHom (Ideal.Quotient.mk (entriesIdeal φ))) Ideal.Quotient.mk_surjective