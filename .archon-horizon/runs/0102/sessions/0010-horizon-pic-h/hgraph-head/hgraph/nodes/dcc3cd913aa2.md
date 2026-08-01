---
author: sync
content_type: theorem
created: '2026-07-20T20:32:02'
decl: AlgebraicGeometry.divUniversalFibreMulMap_surjective
docstring: The finite field-level universal multiplication map is surjective.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivSecondWindowMap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalFibreMulMap_surjective
type: lean
updated: '2026-08-01T09:44:12'
---
theorem divUniversalFibreMulMap_surjective
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (hker : divCarveIdeal k (windowS_choice π hπ g • fiberWeilDivisor π)
      (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j
      ≤ RingHom.ker (algebraMap (PairChartRing k g r₁ g r₂ i j) K))
    (hb : 0 < windowBound π hπ) :
    Function.Surjective
      (divUniversalFibreMulMap C hπ g r₁ r₂ b₁ b₂ i j K hO hχ hker hb) :=
  Scheme.finiteMulMapTo_surjective (ι := Fin (Module.finrank K ↥HS))
    HS KM KMS (Module.finBasis K ↥HS)
    (divUniversalFibre_mulSpan_eq_of_windowBound_pos
      C hπ g r₁ r₂ b₁ b₂ i j K hO hχ hker hb)