/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.AffineOpenStalkLocalization
import AlgebraicJacobian.Picard.LineBundleCoherence
import AlgebraicJacobian.Picard.TensorObjInverse
import Mathlib.RingTheory.Artinian.Module

/-!
# Finite-support tensor rank

This file records the bounded affine algebra used by the finite-support part of
the Picard construction.  There are two ingredients.

* On an affine scheme, a locally trivial module has an invertible module of
  global sections.  The inverse is supplied by `exists_tensorObj_inverse`, and
  the affine section formula turns the tensor contraction into a linear
  equivalence.
* For a finite morphism to `Spec K`, the section ring is a finite `K`-algebra.
  It is therefore Artinian, so an invertible section module is free of rank one.
  Tensoring a quasi-coherent module with the locally trivial module consequently
  preserves `K`-dimension.

The statements stop at this affine finite-support calculation.  No support
descent or fibre-specialisation claim is hidden here.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite
open scoped AlgebraicGeometry TensorProduct

noncomputable section

namespace AlgebraicGeometry.Scheme.Modules

/-! ## Invertible global sections on an affine scheme -/

/-- A locally trivial module on an affine scheme has invertible global sections.

The tensor inverse from `exists_tensorObj_inverse` contracts with the given
module.  Since both factors are quasi-coherent, `tensorSectionHom_isIso` identifies
the sections of their sheaf tensor with the tensor product of their sections.
Applying global sections to the contraction therefore gives a linear equivalence
`Γ(L) ⊗ Γ(L⁻¹) ≃ Γ(D)`, and `Module.Invertible.left` supplies the claimed
invertibility of `Γ(L)`.
-/
theorem locallyTrivial_globalSections_invertible
    {D : Scheme.{u}} [IsAffine D] {L : D.Modules}
    (hL : LineBundle.IsLocallyTrivial L) :
    Module.Invertible Γ(D, (⊤ : D.Opens)) Γ(L, (⊤ : D.Opens)) := by
  haveI : L.IsQuasicoherent := by
    haveI := hL.isFinitePresentation
    infer_instance
  obtain ⟨Linv, hLinv, ⟨e⟩⟩ := exists_tensorObj_inverse hL
  haveI : Linv.IsQuasicoherent := by
    haveI := hLinv.isFinitePresentation
    infer_instance
  haveI : IsIso (tensorSectionHom L Linv (⊤ : D.Opens)) :=
    tensorSectionHom_isIso L Linv (isAffineOpen_top D)
  let ht : (Γ(L, (⊤ : D.Opens)) ⊗[Γ(D, (⊤ : D.Opens))]
      Γ(Linv, (⊤ : D.Opens))) →ₗ[Γ(D, (⊤ : D.Opens))]
      Γ(L.tensorObj Linv, (⊤ : D.Opens)) := by
    exact (tensorSectionHom L Linv (⊤ : D.Opens)).hom
  let he : Γ(L.tensorObj Linv, (⊤ : D.Opens)) ≃ₗ[Γ(D, (⊤ : D.Opens))]
      Γ(D, (⊤ : D.Opens)) :=
    { toFun := (Modules.Hom.app e.hom (⊤ : D.Opens)).hom
      invFun := (Modules.Hom.app e.inv (⊤ : D.Opens)).hom
      map_add' := map_add _
      map_smul' := fun r x => Modules.Hom.app_smul e.hom r x
      left_inv := by
        intro x
        change (Modules.Hom.app (e.hom ≫ e.inv) (⊤ : D.Opens)).hom x = x
        rw [e.hom_inv_id]
        rfl
      right_inv := by
        intro x
        change (Modules.Hom.app e.hom (⊤ : D.Opens)).hom
          ((Modules.Hom.app e.inv (⊤ : D.Opens)).hom x) = x
        change (Modules.Hom.app (e.inv ≫ e.hom) (⊤ : D.Opens)).hom x = x
        rw [e.inv_hom_id]
        rfl }
  let hcomp := he.toLinearMap.comp ht
  have hbij_ht : Function.Bijective ht := by
    exact ConcreteCategory.bijective_of_isIso
      (tensorSectionHom L Linv (⊤ : D.Opens))
  have hbij : Function.Bijective hcomp := he.bijective.comp hbij_ht
  exact Module.Invertible.left (LinearEquiv.ofBijective hcomp hbij)

/-! ## Finite affine tensor rank -/

/-- Tensoring by a locally trivial module preserves the finite base-field
dimension of global sections on a finite affine scheme.

The `K`-actions in the conclusion are the structural actions induced by
`p : D ⟶ Spec K` (transported through `Γ(Spec K, ⊤) ≅ K`).  Finiteness of
`p.appTop` makes `Γ(D, ⊤)` a finite `K`-algebra.  The affine tensor-section
isomorphism and Artinian Picard triviality then identify the twisted sections
with the untwisted sections as `K`-vector spaces.  The quasi-coherence
hypothesis on `F` is exactly the hypothesis needed by the affine section
formula.
-/
theorem finrank_globalSections_tensor_of_finite
    {K : Type u} [Field K] {D : Scheme.{u}}
    (p : D ⟶ Spec (CommRingCat.of K)) [IsFinite p]
    {L F : D.Modules} (hL : LineBundle.IsLocallyTrivial L)
    [F.IsQuasicoherent] :
    (let α : K →+* Γ(D, (⊤ : D.Opens)) :=
      p.appTop.hom.comp ((Scheme.ΓSpecIso (CommRingCat.of K)).inv.hom)
     letI : Algebra K Γ(D, (⊤ : D.Opens)) := α.toAlgebra
     letI : Module K Γ(F, (⊤ : D.Opens)) := Module.compHom _ α
     letI : Module K Γ(L.tensorObj F, (⊤ : D.Opens)) := Module.compHom _ α
     Module.finrank K Γ(L.tensorObj F, (⊤ : D.Opens)) =
       Module.finrank K Γ(F, (⊤ : D.Opens))) := by
  dsimp
  letI : IsAffineHom p := IsFinite.toIsAffineHom
  letI : IsAffine D := isAffine_of_isAffineHom p
  let α : K →+* Γ(D, (⊤ : D.Opens)) :=
    p.appTop.hom.comp ((Scheme.ΓSpecIso (CommRingCat.of K)).inv.hom)
  letI : Algebra K Γ(D, (⊤ : D.Opens)) := α.toAlgebra
  have hf : (p.appTop.hom).Finite := p.finite_appTop
  have hi : ((Scheme.ΓSpecIso (CommRingCat.of K)).inv.hom).Finite :=
    RingHom.Finite.of_surjective _ (ConcreteCategory.bijective_of_isIso _).2
  have hα : α.Finite := by
    exact hf.comp hi
  letI : Module.Finite K Γ(D, (⊤ : D.Opens)) := hα
  letI : Module K Γ(F, (⊤ : D.Opens)) := Module.compHom _ α
  letI : Module K Γ(L, (⊤ : D.Opens)) := Module.compHom _ α
  letI : Module K Γ(L.tensorObj F, (⊤ : D.Opens)) := Module.compHom _ α
  haveI : L.IsQuasicoherent := by
    haveI := hL.isFinitePresentation
    infer_instance
  haveI : IsIso (tensorSectionHom L F (⊤ : D.Opens)) :=
    tensorSectionHom_isIso L F (isAffineOpen_top D)
  haveI : Module.Invertible Γ(D, (⊤ : D.Opens)) Γ(L, (⊤ : D.Opens)) :=
    locallyTrivial_globalSections_invertible hL
  letI : IsArtinianRing Γ(D, (⊤ : D.Opens)) :=
    IsArtinianRing.of_finite K Γ(D, (⊤ : D.Opens))
  let eL : Γ(L, (⊤ : D.Opens)) ≃ₗ[Γ(D, (⊤ : D.Opens))]
      Γ(D, (⊤ : D.Opens)) :=
    (Module.Invertible.free_iff_linearEquiv.mp inferInstance).some
  let et : (Γ(L, (⊤ : D.Opens)) ⊗[Γ(D, (⊤ : D.Opens))]
      Γ(F, (⊤ : D.Opens))) ≃ₗ[Γ(D, (⊤ : D.Opens))]
      Γ(F, (⊤ : D.Opens)) :=
    eL.rTensor Γ(F, (⊤ : D.Opens)) ≪≫ₗ
      TensorProduct.lid Γ(D, (⊤ : D.Opens)) Γ(F, (⊤ : D.Opens))
  let ht : (Γ(L, (⊤ : D.Opens)) ⊗[Γ(D, (⊤ : D.Opens))]
      Γ(F, (⊤ : D.Opens))) →ₗ[Γ(D, (⊤ : D.Opens))]
      Γ(L.tensorObj F, (⊤ : D.Opens)) := by
    exact (tensorSectionHom L F (⊤ : D.Opens)).hom
  have hbij_ht : Function.Bijective ht := by
    exact ConcreteCategory.bijective_of_isIso
      (tensorSectionHom L F (⊤ : D.Opens))
  let htotal := LinearEquiv.ofBijective ht hbij_ht
  let ef := htotal.symm ≪≫ₗ et
  let efK : Γ(L.tensorObj F, (⊤ : D.Opens)) ≃ₗ[K]
      Γ(F, (⊤ : D.Opens)) :=
    { toFun := ef
      invFun := ef.symm
      map_add' := map_add _
      map_smul' := by
        intro c x
        change ef (α c • x) = α c • ef x
        exact ef.map_smul _ _
      left_inv := by
        intro x
        exact ef.symm_apply_apply x
      right_inv := by
        intro x
        exact ef.apply_symm_apply x }
  exact efK.finrank_eq

end AlgebraicGeometry.Scheme.Modules
