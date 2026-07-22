---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.triple_elt_eq
docstring: The tensor-element identity finishing `ΓSpecIso_hom_tripleSection` (pure
  algebra).
file: AlgebraicJacobian/Picard/WitnessAway.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.triple_elt_eq
type: lean
updated: '2026-07-16T21:33:28'
---
private lemma triple_elt_eq (x y z : B) :
    (x ⊗ₜ[A] ((1 : B) ⊗ₜ[A] (1 : B)))
        * (((1 : B) ⊗ₜ[A] (y ⊗ₜ[A] (1 : B))) * ((1 : B) ⊗ₜ[A] ((1 : B) ⊗ₜ[A] z)))
      = (x ⊗ₜ[A] (1 : B ⊗[A] B))
        * ((1 : B) ⊗ₜ[A] ((y ⊗ₜ[A] (1 : B)) * ((1 : B) ⊗ₜ[A] z))) := by
  simp only [Algebra.TensorProduct.tmul_mul_tmul, Algebra.TensorProduct.one_def,
    one_mul, mul_one]

/-- The `ΓSpecIso`-image of `tripleSection` is the two-base localization element of the
triple tensor, in the shape consumed by `isLocalization_away_tensor`. -/
lemma ΓSpecIso_hom_tripleSection (i j l : P.ι) :
    (Scheme.ΓSpecIso (CommRingCat.of (B ⊗[A] (B ⊗[A] B)))).hom.hom (tripleSection P i j l)
      = (awayElt P i ⊗ₜ[A] (1 : B ⊗[A] B))
        * ((1 : B) ⊗ₜ[A] ((awayElt P j ⊗ₜ[A] (1 : B)) * ((1 : B) ⊗ₜ[A] awayElt P l))) := by
  have e₁ : tripleSection P i j l
      = (f₁₂).appTop.hom ((q₁).appTop.hom (P.r i))
        * ((f₁₂).appTop.hom ((q₂).appTop.hom (P.r j))
          * (f₁₃).appTop.hom ((q₂).appTop.hom (P.r l))) := by
    rw [tripleSection_def, appTop_appTop (f₁₂) (q₁), appTop_appTop (f₁₂) (q₂),
      appTop_appTop (f₁₃) (q₂)]
  refine ((congrArg _ e₁).trans (map_mul _ _ _)).trans ?_
  refine (congrArg₂ (· * ·) (hom_f₁₂_q₁_appTop (P.r i))
    ((map_mul _ _ _).trans (congrArg₂ (· * ·) (hom_f₁₂_q₂_appTop (P.r j))
      (hom_f₁₃_q₂_appTop (P.r l))))).trans ?_
  exact triple_elt_eq (awayElt P i) (awayElt P j) (awayElt P l)

open IsLocalization.Away in