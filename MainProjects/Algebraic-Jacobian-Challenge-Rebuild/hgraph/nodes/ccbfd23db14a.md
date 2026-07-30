---
author: sync
content_type: theorem
created: '2026-07-30T06:31:12'
decl: AlgebraicGeometry.map_divisorWindowGrOfQuot
docstring: '**The tower transport of the window point, carrier-free** — the analogue
  of

  `map_divFamWindowGr` (`Picard/DivSchemeFrameCover.lean:188`) with no `DivFam` in
  it.'
file: ScratchWR/probe_r7_nogo_noeth.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.map_divisorWindowGrOfQuot
type: lean
updated: '2026-07-30T20:44:58'
---
theorem map_divisorWindowGrOfQuot (d : (relCurve C R).LocalEquations)
    [Module.Finite R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1)]
    [Module.Projective R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1)]
    (hrank : ∀ p : PrimeSpectrum R, Module.rankAtStalk ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1) p = g)
    (h u : R) (β : Localization.Away h →ₐ[k] Localization.Away u)
    (hβ : β.toRingHom.comp (algebraMap R (Localization.Away h))
      = algebraMap R (Localization.Away u)) :
    Module.Grassmannian.map β
        (divisorWindowGrOfQuot g a ha1 d (Localization.Away h) hrank)
      = divisorWindowGrOfQuot g a ha1 d (Localization.Away u) hrank := by
  letI : Algebra (Localization.Away h) (Localization.Away u) := β.toAlgebra
  letI : IsScalarTower k (Localization.Away h) (Localization.Away u) :=
    IsScalarTower.of_algebraMap_eq' (IsScalarTower.algebraMap_eq k _ _)
  haveI htowerR : IsScalarTower R (Localization.Away h) (Localization.Away u) := by
    refine IsScalarTower.of_algebraMap_eq' ?_
    rw [RingHom.algebraMap_toAlgebra]
    exact hβ.symm
  refine Module.Grassmannian.ext ?_
  rw [Module.Grassmannian.map_toSubmodule β
      (divisorWindowGrOfQuot g a ha1 d (Localization.Away h) hrank),
    divisorWindowGrOfQuot_toSubmodule]
  -- the projective-quotient instance the `ker_baseChangeMkQ` description consumes is the
  -- Grassmannian point's own field, at the intermediate ring
  haveI : Module.Projective (Localization.Away h)
      ((Localization.Away h ⊗[k]
        ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸
        windowBaseChange (Localization.Away h) (divisorWindow d ha1)) :=
    (divisorWindowGrOfQuot g a ha1 d (Localization.Away h) hrank).projective_quotient
  rw [Grassmannian.ker_baseChangeMkQ_eq_map_baseChange (Localization.Away u)
      (windowBaseChange (Localization.Away h) (divisorWindow d ha1)),
    divisorWindowGrOfQuot_toSubmodule]
  exact windowBaseChange_windowBaseChange (Localization.Away h) (Localization.Away u)
    (divisorWindow d ha1)

set_option maxHeartbeats 800000 in
-- The quotient equivalence unfolds the window through the section-ring algebra tower; same
-- elaboration profile as the chart-typed `divFamWindowGrQuotEquiv`.