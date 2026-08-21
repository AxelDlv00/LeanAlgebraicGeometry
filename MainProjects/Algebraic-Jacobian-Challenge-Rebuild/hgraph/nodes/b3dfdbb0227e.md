---
author: sync
content_type: theorem
created: '2026-08-21T08:24:53'
decl: AlgebraicGeometry.locallyOfFiniteType_pic0FiniteGaloisDescent
docstring: 'Local finite type of a Picard-zero representer descends through the glued

  finite Galois quotient.'
file: AlgebraicJacobian/Picard/Pic0FiniteGaloisJacobianData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.locallyOfFiniteType_pic0FiniteGaloisDescent
type: lean
updated: '2026-08-21T08:24:53'
---
theorem locallyOfFiniteType_pic0FiniteGaloisDescent
    (C : Over (Spec (CommRingCat.of K)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    [FiniteDimensional K L] [IsGalois K L]
    {J : Over (Spec (CommRingCat.of L))}
    (rep : (pic0TypeFunctor ((baseChange K L).obj C)).RepresentableBy J)
    (hlft : LocallyOfFiniteType J.hom)
    [((pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen)] :
    LocallyOfFiniteType
      (StableAffineOpen.gluedQuotientMap
        (pic0SemilinearGalActionOfRepresentableBy C rep)) := by
  letI := hlft
  exact IsGaloisQuotient.locallyOfFiniteType
    (StableAffineOpen.isGaloisQuotient_glued
      (pic0SemilinearGalActionOfRepresentableBy C rep))