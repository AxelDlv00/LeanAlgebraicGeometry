---
author: sync
content_type: definition
created: '2026-07-31T02:29:39'
decl: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.stableAffineQuotientMapRestrict
docstring: 'The quotient projection on a stable subopen, obtained by lifting the ambient

  affine quotient map through the corresponding quotient-side open.'
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisQuotientRestrict.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearGalAction.stableAffineQuotientMapRestrict
type: lean
updated: '2026-07-31T02:29:39'
---
noncomputable def stableAffineQuotientMapRestrict [FiniteDimensional K L]
    (hUa : IsAffineOpen U) {V : X.Opens} (hVU : V ≤ U)
    (hV : ρ.IsStableOpen V) :
    letI := ρ.sectionsMulSemiringAction hU
    letI := sectionsAlgebra f U
    letI := sectionsAlgebraK (K := K) f U
    letI := sections_isScalarTower (K := K) f U
    letI := ρ.isSemilinear_sections hU
    let W := quotientOpenOfStableSubopen ρ hU V
    V.toScheme ⟶ W.toScheme := by
  letI := ρ.sectionsMulSemiringAction hU
  letI := sectionsAlgebra f U
  letI := sectionsAlgebraK (K := K) f U
  letI := sections_isScalarTower (K := K) f U
  letI := ρ.isSemilinear_sections hU
  let q := stableAffineQuotientMap ρ hU hUa
  let W := quotientOpenOfStableSubopen ρ hU V
  let j := X.homOfLE hVU
  have hpre : q ⁻¹ᵁ W = U.ι ⁻¹ᵁ V :=
    stableAffineQuotientMap_preimage_quotientOpen ρ hU hUa hVU hV
  have hland : Set.range (j ≫ q) ⊆ Set.range W.ι := by
    rintro _ ⟨x, rfl⟩
    have hx : j x ∈ q ⁻¹ᵁ W := by
      rw [hpre]
      change U.ι (j x) ∈ V
      rw [← Scheme.Hom.comp_apply, Scheme.homOfLE_ι]
      exact x.2
    change q (j x) ∈ W at hx
    exact ⟨⟨q (j x), hx⟩, rfl⟩
  exact IsOpenImmersion.lift W.ι (j ≫ q) hland

@[reassoc]