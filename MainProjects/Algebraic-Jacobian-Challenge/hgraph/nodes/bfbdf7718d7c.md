---
author: sync
content_type: theorem
created: '2026-07-31T02:29:39'
decl: AlgebraicJacobian.GaloisDescent.GaloisQuotientWitness.comparison_comp
docstring: Comparisons of specified quotient witnesses compose transitively.
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisQuotientUniqueness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.GaloisQuotientWitness.comparison_comp
type: lean
updated: '2026-07-31T02:29:39'
---
theorem comparison_comp
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    {rho : SemilinearGalAction K L X f}
    {Y₁ Y₂ Y₃ : Scheme.{u}}
    {g₁ : Y₁ ⟶ Spec (CommRingCat.of K)}
    {g₂ : Y₂ ⟶ Spec (CommRingCat.of K)}
    {g₃ : Y₃ ⟶ Spec (CommRingCat.of K)}
    (w₁ : GaloisQuotientWitness rho Y₁ g₁)
    (w₂ : GaloisQuotientWitness rho Y₂ g₂)
    (w₃ : GaloisQuotientWitness rho Y₃ g₃) :
    (comparison w₁ w₂).1 ≫ (comparison w₂ w₃).1 =
      (comparison w₁ w₃).1 := by
  classical
  let v₁₂ := comparison w₁ w₂
  let v₂₃ := comparison w₂ w₃
  have hbase : (v₁₂.1 ≫ v₂₃.1) ≫ g₃ = g₁ := by
    rw [Category.assoc, v₂₃.2, v₁₂.2]
  have hcomp : pullbackBaseChange K L g₃ g₁ (v₁₂.1 ≫ v₂₃.1) hbase ≫
      w₃.e.hom = w₁.e.hom := by
    rw [pullbackBaseChange_comp K L g₃ g₂ g₁ v₂₃.1 v₂₃.2 v₁₂.1 v₁₂.2,
      Category.assoc, comparison_spec w₂ w₃, comparison_spec w₁ w₂]
  have heq := (w₃.universal Y₁ g₁ w₁.e.hom w₁.over w₁.equivariant).unique
    (y₁ := ⟨v₁₂.1 ≫ v₂₃.1, hbase⟩) (y₂ := comparison w₁ w₃)
    hcomp (comparison_spec w₁ w₃)
  exact congrArg Subtype.val heq