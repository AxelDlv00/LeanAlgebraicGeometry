---
author: sync
content_type: definition
created: '2026-07-30T07:28:28'
decl: AlgebraicGeometry.divisorWindowGrOfQuotEquiv
docstring: 'The quotient of the packaged window point is the base change of the `R`-level
  quotient —

  `divFamWindowGrQuotEquiv` (`Picard/DivSchemeFrameCover.lean:161`) with no carrier:
  it was

  already a statement about the submodule alone.'
file: ScratchWR/probe_r7_nogo_noeth.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divisorWindowGrOfQuotEquiv
type: lean
updated: '2026-07-30T11:13:14'
---
noncomputable def divisorWindowGrOfQuotEquiv (d : (relCurve C R).LocalEquations)
    (R' : Type u) [CommRing R'] [Algebra k R'] [Algebra R R'] [IsScalarTower k R R']
    [Module.Finite R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1)]
    [Module.Projective R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1)]
    (hrank : ∀ p : PrimeSpectrum R, Module.rankAtStalk ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1) p = g) :
    ((R' ⊗[k] ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸
        (divisorWindowGrOfQuot g a ha1 d R' hrank).toSubmodule) ≃ₗ[R']
      R' ⊗[R] ((R ⊗[k]
        ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1) :=
  (Submodule.quotEquivOfEq _ _
      (windowBaseChange_eq_ker_baseChangeMkQ R' (divisorWindow d ha1))).trans
    (Module.Grassmannian.baseChangeMkQEquiv (divisorWindow d ha1))

set_option maxHeartbeats 800000 in
-- Instantiates the free-quotient/matrix kit at the window types; elaboration cost, as for the
-- chart-typed `exists_component_matrix` this replaces.