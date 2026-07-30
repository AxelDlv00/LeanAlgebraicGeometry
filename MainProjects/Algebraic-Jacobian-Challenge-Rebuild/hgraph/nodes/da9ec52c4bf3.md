---
author: sync
content_type: structure
created: '2026-07-24T17:02:46'
decl: Algebra.EtaleCover
docstring: 'A presented étale cover of `Spec A`: a finite-variable polynomial presentation
  of an

  étale `A`-algebra whose spectrum maps onto `Spec A`.  Presentations keep the type
  of covers

  small (`Type u` for `A : Type u`), which is what makes the étale plus construction
  over

  these covers a legitimate colimit; the carrier-level content is recovered by

  `Algebra.EtaleCover.of`/`ofEquiv`.'
file: AlgebraicJacobian/Algebra/EtaleCover.lean
generated: lean
lean_status: lean_ok
stale: true
title: Algebra.EtaleCover
type: lean
updated: '2026-07-30T15:28:04'
---
structure EtaleCover (A : Type u) [CommRing A] : Type u where
  /-- The number of variables of the presentation. -/
  n : ℕ
  /-- The ideal of relations of the presentation. -/
  ideal : Ideal (MvPolynomial (Fin n) A)
  /-- The presented algebra is étale over the base. -/
  etale : Algebra.Etale A (MvPolynomial (Fin n) A ⧸ ideal)
  /-- The spectrum of the presented algebra covers the spectrum of the base. -/
  comap_surjective :
    Function.Surjective (PrimeSpectrum.comap (algebraMap A (MvPolynomial (Fin n) A ⧸ ideal)))

namespace EtaleCover

variable {A : Type u} [CommRing A]