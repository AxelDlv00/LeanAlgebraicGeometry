---
author: sync
content_type: theorem
created: '2026-08-03T14:28:06'
decl: AlgebraicGeometry.Grassmannian.chartIncl_opensRange
docstring: 'The range of a Grassmannian chart localization is the principal open cut

  out by its transition minor.'
file: AlgebraicJacobian/Projective/GrassmannianPluckerGlobalImmersion.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.chartIncl_opensRange
type: lean
updated: '2026-08-18T20:52:09'
---
theorem chartIncl_opensRange (d r : ℕ) (I J : PluckerIndex d r) :
    (chartIncl d r I.1 J.1 I.2 J.2).opensRange =
      PrimeSpectrum.basicOpen (minorDet d r I.1 J.1 I.2 J.2) := by
  change (Spec.map (CommRingCat.ofHom
    (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
      (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))).opensRange = _
  exact TopologicalSpace.Opens.ext
    (PrimeSpectrum.localization_away_comap_range
      (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))
      (minorDet d r I.1 J.1 I.2 J.2))