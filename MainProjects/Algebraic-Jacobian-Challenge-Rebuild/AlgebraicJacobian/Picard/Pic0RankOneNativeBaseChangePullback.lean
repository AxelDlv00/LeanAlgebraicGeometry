/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.Pic0RankOneLocusNative
import AlgebraicJacobian.Cohomology.GluedSheafDatumBaseChange
import AlgebraicJacobian.Cohomology.NativePushforwardBaseChangeAffine
import AlgebraicJacobian.Cohomology.NativePushforwardBaseChangeMate
import AlgebraicJacobian.Cohomology.NativePushforwardBaseChangeOpen
import AlgebraicJacobian.Cohomology.NativePushforwardBaseChangeTensor

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule

variable {k : Type u} [Field k]
variable {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable (B' : Type u) [CommRing B'] [Algebra k B'] [Algebra B B']
  [IsScalarTower k B B']
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]

namespace BasicOpenCocycleDatum

noncomputable section

variable (D : BasicOpenCocycleDatum C B pi)

/-!
# Native pullback comparison

The datum-level `sectionsMap` is already linear over the structure-sheaf map and
commutes with restriction.  It therefore gives a morphism from the native module
to the pushforward of the base-changed native module.  Its adjoint is the
canonical comparison from the geometric pullback of `D.nativeModule` to the
native module rebuilt from `D.baseChange B'`.
-/

/-- `sectionsMap`, assembled as an `O_{C_B}`-linear map into pushforward. -/
noncomputable def nativeModuleSectionsMap :
    D.nativeModule ⟶
      (Scheme.Modules.pushforward (relCurveMap C B B')).obj
        (D.baseChange B').nativeModule :=
  ⟨PresheafOfModules.homMk
    { app := fun U ↦ AddCommGrpCat.ofHom <| AddMonoidHom.mk'
        (fun s ↦ D.sectionsMap B' le_rfl s)
        (fun s t ↦ D.sectionsMap_add B' le_rfl s t)
      naturality := fun {U V} i ↦ by
        ext s
        change D.sectionsMap B' le_rfl
            (gluedRes B D.pieces D.unit i.unop.le s) =
          gluedRes B' (D.baseChange B').pieces (D.baseChange B').unit
            (Scheme.Hom.preimage_mono (relCurveMap C B B') i.unop.le)
            (D.sectionsMap B' le_rfl s)
        exact (D.gluedRes_sectionsMap B' i.unop.le le_rfl le_rfl
          (Scheme.Hom.preimage_mono (relCurveMap C B B') i.unop.le) s).symm }
    (fun U r s ↦ by
      change D.sectionsMap B' le_rfl
          (gluedQsmul B D.pieces D.unit le_rfl r s) =
        gluedQsmul B' (D.baseChange B').pieces (D.baseChange B').unit le_rfl
          (((relCurveMap C B B').app U.unop).hom r) (D.sectionsMap B' le_rfl s)
      simpa only [Scheme.Hom.appLE_eq_app] using
        D.sectionsMap_gluedQsmul B'
          (W := U.unop) (W' := relCurveMap C B B' ⁻¹ᵁ U.unop)
          (V := U.unop) (V' := relCurveMap C B B' ⁻¹ᵁ U.unop)
          le_rfl le_rfl le_rfl le_rfl r s)⟩

@[simp]
theorem nativeModuleSectionsMap_app_apply (U : (relCurve C B).Opens)
    (s : Γ(D.nativeModule, U)) :
    (D.nativeModuleSectionsMap B').app U s = D.sectionsMap B' le_rfl s :=
  rfl

/-- The native module rebuilt from the base-changed datum receives the geometric
pullback of the original native module.  This is adjoint to `sectionsMap` on
every open, with no flatness or finiteness hypothesis on `B → B'`. -/
noncomputable def nativePullbackComparison :
    (Scheme.Modules.pullback (relCurveMap C B B')).obj D.nativeModule ⟶
      (D.baseChange B').nativeModule :=
  ((Scheme.Modules.pullbackPushforwardAdjunction
    (relCurveMap C B B')).homEquiv D.nativeModule
      (D.baseChange B').nativeModule).symm (D.nativeModuleSectionsMap B')

/-- The adjunct of `nativePullbackComparison` is exactly the morphism assembled
from the datum-level `sectionsMap`. -/
@[simp]
theorem nativePullbackComparison_adjunct :
    (Scheme.Modules.pullbackPushforwardAdjunction
      (relCurveMap C B B')).homEquiv D.nativeModule
        (D.baseChange B').nativeModule (D.nativePullbackComparison B') =
      D.nativeModuleSectionsMap B' := by
  exact Equiv.apply_symm_apply _ _

/-- On a full preimage open, the native pullback comparison sends the
adjunction-unit base-map section to the datum-level base-changed section. -/
theorem nativePullbackComparison_baseMap (V : (relCurve C B).Opens)
    (s : Γ(D.nativeModule, V)) :
    ((D.nativePullbackComparison B').app (relCurveMap C B B' ⁻¹ᵁ V)).hom
        (pullback_app_isoTensor_baseMap (relCurveMap C B B') D.nativeModule
          (le_refl (relCurveMap C B B' ⁻¹ᵁ V)) s) =
      D.sectionsMap B' (le_refl (relCurveMap C B B' ⁻¹ᵁ V)) s := by
  have h := congrArg
    (fun (f : D.nativeModule ⟶
        (Scheme.Modules.pushforward (relCurveMap C B B')).obj
          (D.baseChange B').nativeModule) ↦
      (Scheme.Modules.Hom.app f V).hom s)
    (D.nativePullbackComparison_adjunct B')
  rw [Adjunction.homEquiv_unit] at h
  rw [pullback_app_isoTensor_baseMap_le_refl]
  exact h

private theorem unit_hom_ext_top {X : Scheme.{u}} {M : X.Modules}
    (f g : SheafOfModules.unit X.ringCatSheaf ⟶ M)
    (h : f.val.app (.op (⊤ : X.Opens)) (1 : Γ(X, ⊤)) =
      g.val.app (.op (⊤ : X.Opens)) (1 : Γ(X, ⊤))) : f = g := by
  apply (SheafOfModules.fullyFaithfulForget X.ringCatSheaf).map_injective
  apply PresheafOfModules.hom_ext
  intro U
  apply ModuleCat.hom_ext
  apply LinearMap.ext
  intro x
  change Γ(X, U.unop) at x
  change f.val.app U x = g.val.app U x
  rw [show x = x • (1 : Γ(X, U.unop)) by simp, map_smul, map_smul]
  congr 1
  have hf := congrArg (fun k ↦ k.hom (1 : Γ(X, ⊤)))
    ((Scheme.Modules.Hom.mapPresheaf f).naturality
      (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op)
  have hg := congrArg (fun k ↦ k.hom (1 : Γ(X, ⊤)))
    ((Scheme.Modules.Hom.mapPresheaf g).naturality
      (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op)
  change f.val.app U ((X.presheaf.map
      (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op).hom 1) =
    (M.presheaf.map (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op).hom
      (f.val.app (.op (⊤ : X.Opens)) (1 : Γ(X, ⊤))) at hf
  change g.val.app U ((X.presheaf.map
      (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op).hom 1) =
    (M.presheaf.map (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op).hom
      (g.val.app (.op (⊤ : X.Opens)) (1 : Γ(X, ⊤))) at hg
  rw [map_one] at hf hg
  exact hf.trans ((congrArg
    (fun z ↦ (M.presheaf.map
      (homOfLE (le_top : U.unop ≤ (⊤ : X.Opens))).op).hom z) h).trans hg.symm)

private theorem pullbackRestrictIso_baseMap_top
    {X Y : Scheme.{u}} (g : Y ⟶ X) (U : X.Opens)
    (N : X.Modules) (x : Γ(N, U)) :
    (Scheme.Modules.Hom.app
      ((Scheme.Modules.pullbackRestrictIso g U).hom.app N)
        (⊤ : (g ⁻¹ᵁ U).toScheme.Opens)).hom
      (pullback_app_isoTensor_baseMap g N
        (show (g ⁻¹ᵁ U).ι ''ᵁ (⊤ : (g ⁻¹ᵁ U).toScheme.Opens) ≤ g ⁻¹ᵁ U by simp) x) =
      pullback_app_isoTensor_baseMap (g ∣_ U)
        ((Scheme.Modules.restrictFunctor U.ι).obj N)
        (le_top : (⊤ : (g ⁻¹ᵁ U).toScheme.Opens) ≤
          (g ∣_ U) ⁻¹ᵁ (⊤ : U.toScheme.Opens))
        ((N.restrictAppIso U.ι ⊤).inv (by simpa using x)) := by
  have hOpenSource :
      (Scheme.Modules.Hom.app
        ((Scheme.Modules.restrictFunctorIsoPullback (g ⁻¹ᵁ U).ι).hom.app
          ((Scheme.Modules.pullback g).obj N)) ⊤).hom
        (pullback_app_isoTensor_baseMap g N
          (show (g ⁻¹ᵁ U).ι ''ᵁ (⊤ : (g ⁻¹ᵁ U).toScheme.Opens) ≤
            g ⁻¹ᵁ U by simp) x) =
      pullback_app_isoTensor_baseMap (g ⁻¹ᵁ U).ι
        ((Scheme.Modules.pullback g).obj N) le_top
        (pullback_app_isoTensor_baseMap g N (le_refl (g ⁻¹ᵁ U)) x) := by
    simpa only [pullbackOpenImmersionSectionsEquiv,
      Scheme.Opens.opensRange_ι, Scheme.Opens.ι_image_top,
      Scheme.Opens.ι_preimage_self, eqToHom_refl, op_id,
      CategoryTheory.Functor.map_id, AddCommGrpCat.hom_id,
      AddMonoidHom.id_apply] using
      (pullbackOpenImmersionSectionsEquiv_symm_apply (g ⁻¹ᵁ U).ι
        ((Scheme.Modules.pullback g).obj N)
        (by simpa only [Scheme.Opens.opensRange_ι] using
          pullback_app_isoTensor_baseMap g N (le_refl (g ⁻¹ᵁ U)) x))
  have hCompSource := pullback_app_isoTensor_baseMap_comp
    (g ⁻¹ᵁ U).ι g N
    (T := (⊤ : (g ⁻¹ᵁ U).toScheme.Opens))
    (V := g ⁻¹ᵁ U) (U := U)
    (le_refl (g ⁻¹ᵁ U)) le_top le_top x
  have hCongr := pullback_app_isoTensor_baseMap_congr
    (Scheme.morphismRestrict_ι g U).symm N
    (U := (⊤ : (g ⁻¹ᵁ U).toScheme.Opens)) (V := U)
    le_top le_top x
  have hCompTarget := pullback_app_isoTensor_baseMap_comp
    (g ∣_ U) U.ι N
    (T := (⊤ : (g ⁻¹ᵁ U).toScheme.Opens))
    (V := (⊤ : U.toScheme.Opens)) (U := U)
    le_top le_top le_top x
  have hCompTargetInv :
      (Scheme.Modules.Hom.app
        ((Scheme.Modules.pullbackComp (g ∣_ U) U.ι).inv.app N) ⊤).hom
        (pullback_app_isoTensor_baseMap (g ∣_ U ≫ U.ι) N le_top x) =
      pullback_app_isoTensor_baseMap (g ∣_ U)
        ((Scheme.Modules.pullback U.ι).obj N) le_top
        (pullback_app_isoTensor_baseMap U.ι N le_top x) := by
    apply (Scheme.Modules.Hom.app
      ((Scheme.Modules.pullbackComp (g ∣_ U) U.ι).hom.app N) ⊤).hom.injective
    simpa only [← Scheme.Modules.Hom.comp_app, Iso.inv_hom_id_app,
      Scheme.Modules.Hom.id_app, AddCommGrpCat.hom_id, AddMonoidHom.id_apply]
      using hCompTarget
  have hOpenTarget :
      (Scheme.Modules.Hom.app
        ((Scheme.Modules.restrictFunctorIsoPullback U.ι).inv.app N) ⊤).hom
        (pullback_app_isoTensor_baseMap U.ι N le_top x) =
      (N.restrictAppIso U.ι ⊤).inv (by simpa using x) := by
    have h := pullbackOpenImmersionSectionsEquiv_symm_apply U.ι N
      (by simpa only [Scheme.Opens.opensRange_ι] using x)
    apply (Scheme.Modules.Hom.app
      ((Scheme.Modules.restrictFunctorIsoPullback U.ι).hom.app N) ⊤).hom.injective
    simpa only [pullbackOpenImmersionSectionsEquiv,
      Scheme.Opens.opensRange_ι, Scheme.Opens.ι_image_top,
      Scheme.Opens.ι_preimage_self, eqToHom_refl, op_id,
      CategoryTheory.Functor.map_id, AddCommGrpCat.hom_id,
      AddMonoidHom.id_apply, ← Scheme.Modules.Hom.comp_app,
      Iso.inv_hom_id_app, Scheme.Modules.Hom.id_app] using h.symm
  have hNatural := pullback_app_isoTensor_baseMap_naturality (g ∣_ U)
    ((Scheme.Modules.restrictFunctorIsoPullback U.ι).inv.app N)
    (U := (⊤ : (g ⁻¹ᵁ U).toScheme.Opens))
    (V := (⊤ : U.toScheme.Opens)) le_top
    (pullback_app_isoTensor_baseMap U.ι N le_top x)
  change
    (Scheme.Modules.Hom.app
      ((Scheme.Modules.pullback (g ∣_ U)).map
        ((Scheme.Modules.restrictFunctorIsoPullback U.ι).inv.app N)) ⊤).hom
      ((Scheme.Modules.Hom.app
        ((Scheme.Modules.pullbackComp (g ∣_ U) U.ι).inv.app N) ⊤).hom
        ((Scheme.Modules.Hom.app
          ((Scheme.Modules.pullbackCongr
            (Scheme.morphismRestrict_ι g U).symm).hom.app N) ⊤).hom
          ((Scheme.Modules.Hom.app
            ((Scheme.Modules.pullbackComp (g ⁻¹ᵁ U).ι g).hom.app N) ⊤).hom
            ((Scheme.Modules.Hom.app
              ((Scheme.Modules.restrictFunctorIsoPullback
                (g ⁻¹ᵁ U).ι).hom.app
                ((Scheme.Modules.pullback g).obj N)) ⊤).hom
              (pullback_app_isoTensor_baseMap g N
                (show (g ⁻¹ᵁ U).ι ''ᵁ
                  (⊤ : (g ⁻¹ᵁ U).toScheme.Opens) ≤ g ⁻¹ᵁ U by simp) x))))) = _
  rw [hOpenSource, hCompSource, hCongr, hCompTargetInv, hNatural, hOpenTarget]

/-- On every cocycle piece, the geometric pullback of the native module is canonically
trivial: restrict pullback to the full preimage, pull back the original piece
trivialization, then identify the pullback of the unit module with the unit module. -/
noncomputable def nativePullbackPieceSheafIso (j : D.index) :
    (Scheme.Modules.restrictFunctor ((D.baseChange B').pieces j).ι).obj
        ((Scheme.Modules.pullback (relCurveMap C B B')).obj D.nativeModule) ≅
      SheafOfModules.unit ((D.baseChange B').pieces j).toScheme.ringCatSheaf := by
  rw [D.pieces_baseChange B' j]
  exact
    (Scheme.Modules.pullbackRestrictIso (relCurveMap C B B') (D.pieces j)).app
        D.nativeModule ≫≅
      (Scheme.Modules.pullback ((relCurveMap C B B') ∣_ D.pieces j)).mapIso
        (D.nativeModulePieceSheafIso j) ≫≅
      Scheme.Modules.pullbackUnitIso ((relCurveMap C B B') ∣_ D.pieces j)

end

end BasicOpenCocycleDatum

end AlgebraicGeometry
