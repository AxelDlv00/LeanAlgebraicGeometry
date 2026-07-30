---
author: sync
content_type: theorem
created: '2026-07-30T21:42:36'
decl: AlgebraicJacobian.GaloisDescent.quotientUniqueIso_inv_base
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisQuotientUniqueness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.quotientUniqueIso_inv_base
type: lean
updated: '2026-07-30T21:42:36'
---
theorem quotientUniqueIso_inv_base
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (rho : SemilinearGalAction K L X f)
    {Y₁ Y₂ : Scheme.{u}}
    {g₁ : Y₁ ⟶ Spec (CommRingCat.of K)}
    {g₂ : Y₂ ⟶ Spec (CommRingCat.of K)}
    (h₁ : IsGaloisQuotient rho g₁) (h₂ : IsGaloisQuotient rho g₂) :
    (quotientUniqueIso rho h₁ h₂).inv ≫ g₁ = g₂ :=
  (quotientComparison rho h₂ h₁).2