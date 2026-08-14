---
author: sync
content_type: theorem
created: '2026-08-14T14:17:16'
decl: AlgebraicJacobian.GaloisDescent.StableAffineOpen.gluedQuotientOverHomEquiv_precomp
docstring: The glued-quotient equivalence is natural under precomposition.
file: AlgebraicJacobian/Picard/Pic0FiniteGaloisDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.StableAffineOpen.gluedQuotientOverHomEquiv_precomp
type: lean
updated: '2026-08-14T14:17:16'
---
theorem gluedQuotientOverHomEquiv_precomp
    [FiniteDimensional K L] [IsGalois K L] [rho.OrbitsInAffineOpen]
    {T T' : Over (Spec (CommRingCat.of K))} (a : T' ⟶ T)
    (b : T ⟶ gluedQuotientOver rho) :
    gluedQuotientOverHomEquiv rho T' (a ≫ b) =
      GaloisEquivariantOver.precomp rho a (gluedQuotientOverHomEquiv rho T b) :=
  GaloisQuotientWitness.overHomEquiv_precomp
    (gluedGaloisQuotientWitness rho).toGaloisQuotientWitness a b