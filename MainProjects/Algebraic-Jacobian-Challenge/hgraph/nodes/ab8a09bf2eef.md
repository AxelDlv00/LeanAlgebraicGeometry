---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite
docstring: '**Generic freeness, finite-module case.** For a noetherian integral domain

  `A` and a finite `A`-module `M`, there is a non-zero `f ∈ A` such that the

  localisation `M_f` is free over `A_f = Localization.Away f`.


  This is the `d = 0` (finite-morphism) special case of the algebraic

  generic-flatness theorem (`thm:generic_flatness_algebraic`, Nitsure~\S4):

  inverting the generic point `Frac A`, the localised module is a finite vector

  space hence free, and `Module.FinitePresentation.exists_free_localizedModule_powers`

  descends that freeness to a single basic open `D(f) ⊆ Spec A`.'
file: AlgebraicJacobian/Picard/FlatteningStratification.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite
type: lean
updated: '2026-07-16T21:14:26'
---
theorem exists_free_localizationAway_of_finite
    (A : Type*) (M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A]
    [AddCommGroup M] [Module A M] [Module.Finite A M] :
    ∃ f : A, f ≠ 0 ∧
      Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M) := by
  haveI : Module.FinitePresentation A M := Module.finitePresentation_of_finite A M
  obtain ⟨r, hr, hfree, _⟩ :=
    Module.FinitePresentation.exists_free_localizedModule_powers (nonZeroDivisors A)
      (LocalizedModule.mkLinearMap (nonZeroDivisors A) M) (FractionRing A)
  exact ⟨r, nonZeroDivisors.ne_zero hr, hfree⟩