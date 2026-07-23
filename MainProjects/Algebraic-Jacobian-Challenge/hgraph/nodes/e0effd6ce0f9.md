---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.awayLift_mul_eq
docstring: '**The `awayLift` normal form**: `awayLift ψ (a / fⁿ) · ψ(f)ⁿ = ψ(a)`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/NonconstantToP1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.awayLift_mul_eq
type: lean
updated: '2026-07-24T03:02:13'
---
private lemma awayLift_mul_eq {f : MvPolynomial (ULift.{u} (Fin 2)) (ULift.{u} ℤ)} {i : ℕ}
    (hf : f ∈ homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ) i)
    (ψ : MvPolynomial (ULift.{u} (Fin 2)) (ULift.{u} ℤ) →+* B) (hu : IsUnit (ψ f)) (n : ℕ)
    (a : MvPolynomial (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
    (ha : a ∈ homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ) (n • i)) :
    awayLift f ψ hu
        (Away.mk (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ)) hf n a ha)
      * ψ f ^ n = ψ a := by
  have hspec : (Localization.mk a (⟨f ^ n, n, rfl⟩ : Submonoid.powers f))
      * algebraMap _ (Localization.Away f) (f ^ n) = algebraMap _ (Localization.Away f) a := by
    rw [Localization.mk_eq_mk'_apply]
    exact IsLocalization.mk'_spec _ _ _
  have hlift := congrArg (IsLocalization.Away.lift (S := Localization.Away f) f hu) hspec
  rw [map_mul, IsLocalization.Away.lift_eq, IsLocalization.Away.lift_eq] at hlift
  calc awayLift f ψ hu
          (Away.mk (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ)) hf n a ha)
        * ψ f ^ n
      = IsLocalization.Away.lift (S := Localization.Away f) f hu
          (Localization.mk a (⟨f ^ n, n, rfl⟩ : Submonoid.powers f)) * ψ (f ^ n) := by
        rw [awayLift, RingHom.comp_apply, HomogeneousLocalization.algebraMap_apply,
          HomogeneousLocalization.Away.val_mk, map_pow]
    _ = ψ a := hlift