---
author: sync
content_type: definition
created: '2026-07-31T02:29:39'
decl: AlgebraicJacobian.GaloisDescent.GaloisQuotientWitness.uniqueIso
docstring: The canonical isomorphism determined by two specified quotient witnesses.
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisQuotientUniqueness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.GaloisQuotientWitness.uniqueIso
type: lean
updated: '2026-07-31T03:47:20'
---
noncomputable def uniqueIso
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    {rho : SemilinearGalAction K L X f}
    {Y₁ Y₂ : Scheme.{u}}
    {g₁ : Y₁ ⟶ Spec (CommRingCat.of K)}
    {g₂ : Y₂ ⟶ Spec (CommRingCat.of K)}
    (w₁ : GaloisQuotientWitness rho Y₁ g₁)
    (w₂ : GaloisQuotientWitness rho Y₂ g₂) : Y₁ ≅ Y₂ where
  hom := (comparison w₁ w₂).1
  inv := (comparison w₂ w₁).1
  hom_inv_id := by rw [comparison_comp, comparison_self]
  inv_hom_id := by rw [comparison_comp, comparison_self]

end GaloisQuotientWitness

namespace GaloisQuotientWitnessWithProjection

/-- The pinned quotient projection lies over the base field. -/
@[reassoc]