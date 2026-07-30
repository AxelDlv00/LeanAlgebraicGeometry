---
author: sync
content_type: theorem
created: '2026-07-31T02:29:39'
decl: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.quotientOpenOfStableSubopen_mono
docstring: 'The quotient-open construction is monotone on stable subopens of a fixed

  stable affine chart.'
file: AlgebraicJacobian/Picard/GaloisDescent/InvariantQuotientOpen.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.quotientOpenOfStableSubopen_mono
type: lean
updated: '2026-07-31T02:29:39'
---
theorem quotientOpenOfStableSubopen_mono [FiniteDimensional K L]
    (hUa : IsAffineOpen U) {V W : X.Opens}
    (hVU : V ≤ U) (hWU : W ≤ U) (hVW : V ≤ W)
    (hV : ρ.IsStableOpen V) (hW : ρ.IsStableOpen W) :
    letI := ρ.sectionsMulSemiringAction hU
    letI := sectionsAlgebra f U
    letI := sectionsAlgebraK (K := K) f U
    letI := sections_isScalarTower (K := K) f U
    letI := ρ.isSemilinear_sections hU
    quotientOpenOfStableSubopen ρ hU V ≤
      quotientOpenOfStableSubopen ρ hU W := by
  letI := ρ.sectionsMulSemiringAction hU
  letI := sectionsAlgebra f U
  letI := sectionsAlgebraK (K := K) f U
  letI := sections_isScalarTower (K := K) f U
  letI := ρ.isSemilinear_sections hU
  intro y hy
  obtain ⟨x, rfl⟩ := stableAffineQuotientMap_surjective ρ hU hUa y
  have hxV : x ∈ U.ι ⁻¹ᵁ V := by
    rw [← stableAffineQuotientMap_preimage_quotientOpen
      ρ hU hUa hVU hV]
    exact hy
  have hxW : x ∈ U.ι ⁻¹ᵁ W := hVW hxV
  rw [← stableAffineQuotientMap_preimage_quotientOpen
    ρ hU hUa hWU hW] at hxW
  exact hxW