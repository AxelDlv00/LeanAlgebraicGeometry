/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.Pic0RankOneNativeBaseChangeH0
import AlgebraicJacobian.Picard.Pic0RankOneNativeBaseChangePullback
import AlgebraicJacobian.Cohomology.NativePushforwardBaseChangeOpen
import Mathlib.AlgebraicGeometry.Modules.Tilde
import Mathlib.RingTheory.Localization.BaseChange

/-!
# Affine presentation of the native rank-one pushforward

The native degree-zero base-change equivalence identifies localization of global
sections with sections after base change.  The native pullback comparison and the
open-immersion sections equivalence then identify those sections with restriction
to the corresponding principal open.  Thus the actual native pushforward is
localizing on `Spec B`, so its canonical affine presentation is an isomorphism.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule

variable {k : Type u} [Field k]
variable {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable {pi : C.left ⟶ P1 k} [IsFinite pi]

namespace BasicOpenCocycleDatum

noncomputable section

variable (D : BasicOpenCocycleDatum C B pi)

local instance nativeSectionsModule (U : (relCurve C B).Opens) :
    Module B Γ(D.nativeModule, U) :=
  Scheme.moduleKSections
    (Over.mk (relCurve C B ↘ Spec (.of B))) D.nativeModule U

/-- The actual native pushforward on the affine base is presented by its module
of global sections as soon as the datum has vanishing first cohomology. -/
theorem isIso_nativePushforward_fromTildeΓ
    (hH1 : Subsingleton (datumPair D).H1) :
    IsIso (((Scheme.Modules.pushforward
      (relCurve C B ↘ Spec (.of B))).obj D.nativeModule).fromTildeΓ) := by
  rw [isIso_fromTildeΓ_iff_isLocalizing]
  intro f
  let S := Localization.Away f
  haveI : IsOpenImmersion (overSpecMap (k := k) B S).left := by
    rw [overSpecMap_left]
    exact IsOpenImmersion.of_isLocalization f
  haveI : IsOpenImmersion (relCurveMap C B S) := by
    infer_instance
  have hRange : (relCurveMap C B S).opensRange =
      (relCurve C B ↘ Spec (.of B)) ⁻¹ᵁ
        (Spec (.of B)).basicOpen f := by
    apply Opens.ext
    change Set.range (relCurveMap C B S).base = _
    rw [Over.range_whiskerLeft C (overSpecMap (k := k) B S)]
    rw [PrimeSpectrum.localization_away_comap_range S f]
  letI nativeBaseChangedSectionsModule
      (U : (relCurve C S).Opens) :
      Module S Γ((D.baseChange S).nativeModule, U) :=
    Scheme.moduleKSections
      (Over.mk (relCurve C S ↘ Spec (.of S)))
      (D.baseChange S).nativeModule U
  letI nativePullbackSectionsModule
      (U : (relCurve C S).Opens) :
      Module S Γ((Scheme.Modules.pullback
        (relCurveMap C B S)).obj D.nativeModule, U) :=
    Scheme.moduleKSections
      (Over.mk (relCurve C S ↘ Spec (.of S)))
      ((Scheme.Modules.pullback (relCurveMap C B S)).obj D.nativeModule) U
  letI nativeBaseChangedSectionsModuleB
      (U : (relCurve C S).Opens) :
      Module B Γ((D.baseChange S).nativeModule, U) :=
    Module.compHom _ (algebraMap B S)
  letI nativePullbackSectionsModuleB
      (U : (relCurve C S).Opens) :
      Module B Γ((Scheme.Modules.pullback
        (relCurveMap C B S)).obj D.nativeModule, U) :=
    Module.compHom _ (algebraMap B S)
  let eH0 : S ⊗[B] Γ(D.nativeModule, ⊤) ≃ₗ[B]
      Γ((D.baseChange S).nativeModule, ⊤) :=
    (D.nativeH0BaseChange S hH1).restrictScalars B
  letI : IsIso (D.nativePullbackComparison S) :=
    D.isIso_nativePullbackComparison S
  let eComparisonS : Γ((D.baseChange S).nativeModule, ⊤) ≃ₗ[S]
      Γ((Scheme.Modules.pullback
        (relCurveMap C B S)).obj D.nativeModule, ⊤) :=
    ((asIso ((D.nativePullbackComparison S).app ⊤)).toLinearEquiv.symm).restrictScalars S
  let eComparison := eComparisonS.restrictScalars B
  let eOpenAdd := pullbackOpenImmersionSectionsEquiv
    (relCurveMap C B S) D.nativeModule
  let eOpen : Γ((Scheme.Modules.pullback
        (relCurveMap C B S)).obj D.nativeModule, ⊤) ≃ₗ[B]
      Γ(D.nativeModule, (relCurveMap C B S).opensRange) :=
    eOpenAdd.toLinearEquiv (by
      intro b x
      change eOpenAdd (b • x) = b • eOpenAdd x
      apply eOpenAdd.symm.injective
      rw [eOpenAdd.symm_apply_apply,
        pullbackOpenImmersionSectionsEquiv_symm_apply]
      rw [map_smul]
      rw [← pullbackOpenImmersionSectionsEquiv_symm_apply,
        eOpenAdd.symm_apply_apply]
      rw [relCurveMap_appLE_overAlgebraMap]
      change b • x =
        (relCurve C S).overAlgebraMap S ⊤ (algebraMap B S b) • x
      rfl)
  let eRange : Γ(D.nativeModule, (relCurveMap C B S).opensRange) ≃ₗ[B]
      Γ(D.nativeModule,
        (relCurve C B ↘ Spec (.of B)) ⁻¹ᵁ
          (Spec (.of B)).basicOpen f) :=
    LinearEquiv.cast (M := fun U : (relCurve C B).Opens ↦ Γ(D.nativeModule, U)) hRange
  let e := eH0.trans (eComparison.trans (eOpen.trans eRange))
  have eComparison_sectionsMap (x : Γ(D.nativeModule, ⊤)) :
      eComparison (D.sectionsMap S le_rfl x) =
        pullback_app_isoTensor_baseMap (relCurveMap C B S) D.nativeModule
          (le_refl (relCurveMap C B S ⁻¹ᵁ (⊤ : (relCurve C B).Opens))) x := by
    change ((asIso ((D.nativePullbackComparison S).app ⊤)).toLinearEquiv.symm)
        (D.sectionsMap S le_rfl x) = _
    rw [LinearEquiv.eq_symm_apply]
    simpa only [Scheme.Hom.preimage_top] using
      D.nativePullbackComparison_baseMap S (⊤ : (relCurve C B).Opens) x
  have eOpen_baseMap (x : Γ(D.nativeModule, ⊤)) :
      eOpen
          (pullback_app_isoTensor_baseMap (relCurveMap C B S) D.nativeModule
            (le_refl (relCurveMap C B S ⁻¹ᵁ (⊤ : (relCurve C B).Opens))) x) =
        (D.nativeModule.presheaf.map
          (homOfLE (le_top : (relCurveMap C B S).opensRange ≤ ⊤)).op).hom x := by
    change eOpenAdd _ = _
    apply eOpenAdd.symm.injective
    rw [eOpenAdd.symm_apply_apply,
      pullbackOpenImmersionSectionsEquiv_symm_apply]
    have hres := pullback_app_isoTensor_baseMap_res
      (relCurveMap C B S) D.nativeModule
      (le_refl (relCurveMap C B S ⁻¹ᵁ (⊤ : (relCurve C B).Opens)))
      (le_of_eq (Scheme.Hom.preimage_opensRange (relCurveMap C B S)).symm)
      (le_top : (relCurveMap C B S).opensRange ≤ ⊤)
      (le_of_eq (Scheme.Hom.preimage_top (relCurveMap C B S)).symm) x
    simpa only [Scheme.Hom.preimage_top,
      show (homOfLE (le_refl (⊤ : (relCurve C S).Opens))).op =
        𝟙 (Opposite.op (⊤ : (relCurve C S).Opens)) from rfl,
      CategoryTheory.Functor.map_id, AddCommGrpCat.hom_id,
      AddMonoidHom.id_apply] using hres
  have e_one_tmul (x : Γ(D.nativeModule, ⊤)) :
      e (1 ⊗ₜ[B] x) =
        (D.nativeModule.presheaf.map
          (homOfLE (le_top :
            (relCurve C B ↘ Spec (.of B)) ⁻¹ᵁ
              (Spec (.of B)).basicOpen f ≤ ⊤)).op).hom x := by
    change eRange (eOpen (eComparison (eH0 (1 ⊗ₜ[B] x)))) = _
    rw [show eH0 (1 ⊗ₜ[B] x) = D.sectionsMap S le_rfl x from
      D.nativeH0BaseChange_one_tmul_eq_sectionsMap S hH1 x]
    rw [eComparison_sectionsMap, eOpen_baseMap]
    cases hRange
    rfl
  let res : Γ(D.nativeModule, ⊤) →ₗ[B]
      Γ(D.nativeModule,
        (relCurve C B ↘ Spec (.of B)) ⁻¹ᵁ
          (Spec (.of B)).basicOpen f) :=
    ((Scheme.toModuleKSheafOfModules
      (Over.mk (relCurve C B ↘ Spec (.of B))) D.nativeModule).obj.map
        (homOfLE le_top).op).hom
  change IsLocalizedModule (Submonoid.powers f) res
  have heq : e.toLinearMap ∘ₗ
      TensorProduct.mk B S Γ(D.nativeModule, ⊤) 1 = res := by
    apply LinearMap.ext
    intro x
    exact e_one_tmul x
  rw [← heq]
  exact IsLocalizedModule.of_linearEquiv _ _ e

end

end BasicOpenCocycleDatum

end AlgebraicGeometry
