---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.GaloisDescent.isEquivariantAlgHom_iff_specMap
docstring: 'Equivariance of an `L`-algebra map matches equivariance of the corresponding

  morphism of affine schemes (with the `toSpecAut` actions on both sides).'
file: AlgebraicJacobian/Picard/FiniteGaloisQuotient.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.isEquivariantAlgHom_iff_specMap
type: lean
updated: '2026-07-16T21:14:26'
---
lemma isEquivariantAlgHom_iff_specMap (φ : A →ₐ[L] L ⊗[K] B) :
    IsEquivariantAlgHom K L A B φ ↔
      ∀ γ : L ≃ₐ[K] L,
        (toSpecAut (L ≃ₐ[K] L) (L ⊗[K] B) γ).hom ≫ Spec.map (CommRingCat.ofHom φ.toRingHom)
          = Spec.map (CommRingCat.ofHom φ.toRingHom) ≫ (toSpecAut (L ≃ₐ[K] L) A γ).hom := by
  have key : ∀ γ : L ≃ₐ[K] L,
      ((toSpecAut (L ≃ₐ[K] L) (L ⊗[K] B) γ).hom ≫ Spec.map (CommRingCat.ofHom φ.toRingHom)
          = Spec.map (CommRingCat.ofHom φ.toRingHom) ≫ (toSpecAut (L ≃ₐ[K] L) A γ).hom)
        ↔ ∀ x : A, γ⁻¹ • φ x = φ (γ⁻¹ • x) := by
    intro γ
    rw [toSpecAut_hom, toSpecAut_hom, ← Spec.map_comp, ← Spec.map_comp,
      ← CommRingCat.ofHom_comp, ← CommRingCat.ofHom_comp]
    constructor
    · intro h
      have h2 := congrArg CommRingCat.Hom.hom (Spec.map_injective h)
      rw [CommRingCat.hom_ofHom, CommRingCat.hom_ofHom] at h2
      exact fun x => DFunLike.congr_fun h2 x
    · intro h
      congr 1
      exact CommRingCat.hom_ext (RingHom.ext h)
  constructor
  · intro hφ γ
    rw [key γ]
    intro x
    rw [galTensor_smul_def, ← hφ γ⁻¹ x]
  · intro hs γ x
    have h3 := (key γ⁻¹).mp (hs γ⁻¹) x
    rw [inv_inv, galTensor_smul_def] at h3
    exact h3.symm

open Algebra in