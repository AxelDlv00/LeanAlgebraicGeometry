---
author: sync
content_type: theorem
created: '2026-07-17T08:41:24'
decl: IsLocalizedModule.bijective_of_comp_eq
docstring: '**A map intertwining two localizations is bijective**: if `p : M → P`
  and

  `q : M → Q` are both localizations at `S` and `T ∘ p = q`, then `T` is bijective
  —

  the uniqueness of localizations, in the form consumed by the span-locality

  bijectivity argument.'
file: AlgebraicJacobian/Cohomology/GluedBaseChangeAlgebra.lean
generated: lean
lean_status: lean_ok
title: IsLocalizedModule.bijective_of_comp_eq
type: lean
updated: '2026-07-29T15:31:34'
---
theorem IsLocalizedModule.bijective_of_comp_eq (p : M →ₗ[R] P) (q : M →ₗ[R] Q)
    [IsLocalizedModule S p] [IsLocalizedModule S q] (T : P →ₗ[R] Q)
    (h : T ∘ₗ p = q) : Function.Bijective T := by
  -- the inverse, by the universal property of `q`
  set T' : Q →ₗ[R] P := IsLocalizedModule.lift S q p (IsLocalizedModule.map_units p)
    with hT'
  have hT'q : T' ∘ₗ q = p := IsLocalizedModule.lift_comp S q p _
  have h₁ : (T' ∘ₗ T) ∘ₗ p = LinearMap.id (R := R) (M := P) ∘ₗ p := by
    rw [LinearMap.comp_assoc, h, hT'q, LinearMap.id_comp]
  have h₂ : (T ∘ₗ T') ∘ₗ q = LinearMap.id (R := R) (M := Q) ∘ₗ q := by
    rw [LinearMap.comp_assoc, hT'q, h, LinearMap.id_comp]
  have hleft : T' ∘ₗ T = LinearMap.id :=
    IsLocalizedModule.linearMap_ext S p p h₁
  have hright : T ∘ₗ T' = LinearMap.id :=
    IsLocalizedModule.linearMap_ext S q q h₂
  exact Function.bijective_iff_has_inverse.mpr
    ⟨T', fun x => DFunLike.congr_fun hleft x, fun x => DFunLike.congr_fun hright x⟩