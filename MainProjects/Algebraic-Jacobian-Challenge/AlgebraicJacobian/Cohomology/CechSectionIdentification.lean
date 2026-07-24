/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.CechSectionIdentificationLegAux

/-!
# Sectionwise Čech comparison

This file transports the evaluated augmented Čech complex to the concrete section complex.
-/

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

open Scheme.Modules

variable {X : Scheme.{u}}

/-- **Canonical augmentation of the concrete section Čech complex over `V`.**  The evaluated
Čech augmentation `G_V(Ψ(cechAugmentation))` (the restriction-product map `Γ(V, F) → ∏_i
Γ(U_i ∩ V, F)`) transported across the degree-`0` object iso `coreIso_objIso`.  This is the
shared augmentation node `D'_aug = (sectionCechComplexV …).augment ε hε` used by BOTH
`cechSection_complex_iso` (`D ≅ D'_aug`) and `cechSection_contractible`
(`Homotopy (𝟙 D'_aug) 0`), so the consumer glue `isZero_homology_of_iso_homotopy_id_zero`
matches their `D'`.  (The scaffold previously took `ε` as a free parameter, which makes both
lemmas false for a non-canonical `ε`; the consumer `hSec` calls them with no `ε`.) -/
noncomputable def sectionCechAugV (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules)
    (V : TopologicalSpace.Opens X) :
    ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj (Opposite.op V) ⟶
      (sectionCechComplexV 𝒰 F V).X 0 :=
  (PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
      (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)).map
    ((SheafOfModules.forget X.ringCatSheaf ⋙
      PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).map (cechAugmentation 𝒰 F)) ≫
    (coreIso_objIso 𝒰 F 0 V).hom

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
-- raised: the reverse `← Functor.map_comp` folds over the 5-fold composite `GV ∘ Ψ` are
-- whnf-intensive on the heavily-whiskered section/pushforward types.
/-- The canonical section-Čech augmentation composes to zero with the first differential.
Transported from the backbone identity `cechAugmentation_comp_d` through `coreIso_comm`. -/
lemma sectionCechAugV_comp_d (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules)
    (V : TopologicalSpace.Opens X) :
    sectionCechAugV 𝒰 F V ≫ (sectionCechComplexV 𝒰 F V).d 0 1 = 0 := by
  rw [sectionCechAugV, Category.assoc]
  erw [coreIso_comm 𝒰 F V 0 1 rfl]
  rw [Functor.mapHomologicalComplex_obj_d, Functor.mapHomologicalComplex_obj_d]
  -- The leading composite `(GV∘Ψ)(cechAug) ≫ (GV∘Ψ)(d⁰)` is zero because `cechAug ≫ d⁰ = 0`
  -- (`cechAugmentation_comp_d`) and `GV ∘ Ψ` is a functor.  We assemble this in pure term mode
  -- (`Functor.map_comp`/`map_zero`/`Category.assoc`) since `rw`/`simp`/`erw` stall on the
  -- bundled-`AddCommGrpCat`-hom representation of the composite functors' `.map`.
  set Ψ := SheafOfModules.forget X.ringCatSheaf ⋙
    PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj) with hΨ
  set GV := PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
    (evaluation (TopologicalSpace.Opens ↥X)ᵒᵖ AddCommGrpCat).obj (op V) with hGV
  have hXY : Ψ.map (cechAugmentation 𝒰 F) ≫ Ψ.map ((cechComplexOnX 𝒰 F).d 0 1) = 0 :=
    (Ψ.map_comp _ _).symm.trans
      ((congrArg Ψ.map (cechAugmentation_comp_d 𝒰 F)).trans (Functor.map_zero Ψ _ _))
  have key : GV.map (Ψ.map (cechAugmentation 𝒰 F)) ≫
      GV.map (Ψ.map ((cechComplexOnX 𝒰 F).d 0 1)) = 0 :=
    (GV.map_comp _ _).symm.trans ((congrArg GV.map hXY).trans (Functor.map_zero GV _ _))
  exact (Category.assoc _ _ _).symm.trans
    ((congrArg (· ≫ (coreIso_objIso 𝒰 F 1 V).hom) key).trans Limits.zero_comp)

/-- The evaluated augmented Čech complex is the augmented concrete section complex. -/
noncomputable def cechSection_complex_iso (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (V : TopologicalSpace.Opens X) :
    let α : X.ringCatSheaf.obj ⟶ X.ringCatSheaf.obj := 𝟙 X.ringCatSheaf.obj
    let cc := ComplexShape.up ℕ
    let K := cechAugmentedComplex 𝒰 F
    let Kp := ((SheafOfModules.forget X.ringCatSheaf ⋙
        PresheafOfModules.restrictScalars α).mapHomologicalComplex cc).obj K
    let GV :=
      PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙
      (evaluation (TopologicalSpace.Opens X)ᵒᵖ AddCommGrpCat).obj (Opposite.op V)
    let D := (GV.mapHomologicalComplex cc).obj Kp
    D ≅ (sectionCechComplexV 𝒰 F V).augment (sectionCechAugV 𝒰 F V)
      (sectionCechAugV_comp_d 𝒰 F V) := by
  intro α cc K Kp GV D
  -- The push–pull functor `Ψ` through which the evaluated complex `D` is built.  We keep it
  -- inline (rather than abstracted by `set`) so the `Ψ.Additive` instance resolves directly.
  haveI hΨadd :
      (SheafOfModules.forget X.ringCatSheaf ⋙ PresheafOfModules.restrictScalars α).Additive :=
    inferInstance
  haveI : GV.Additive := inferInstance
  -- (CORE, residual) Non-augmented degreewise iso + differential match: the evaluated
  -- non-augmented Čech complex `Γ(V, C•)` is the concrete section Čech complex over the
  -- restricted family `U'_σ = coverInterOpen 𝒰 σ ⊓ V`.  Degreewise object iso is
  -- `pushPull_eval_prod_iso` (Stub 4); the differential match is via `sectionCech_objD_apply`.
  -- `coreIso` and `eY` are kept as `let`-bindings (transparent), so the degree-`0` identity
  -- `(isoApp coreIso 0).hom = (coreIso_objIso 𝒰 F 0 V).hom` and `eY.hom = 𝟙` hold definitionally,
  -- which is what makes `hcompat` close (the canonical `sectionCechAugV` is exactly the evaluated
  -- Čech augmentation transported across `coreIso_objIso 0`).
  let coreIso : (GV.mapHomologicalComplex cc).obj
        (((SheafOfModules.forget X.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars α).mapHomologicalComplex cc).obj
            (cechComplexOnX 𝒰 F)) ≅ sectionCechComplexV 𝒰 F V :=
    HomologicalComplex.Hom.isoOfComponents (fun p => coreIso_objIso 𝒰 F p V)
      (coreIso_comm 𝒰 F V)
  -- (adapter) The augmentation node `GV(Ψ F)` is the section group `Γ(V, F)`: definitional,
  -- since `restrictScalars (𝟙 ·)` and `toPresheaf` leave the underlying abelian-group presheaf
  -- unchanged and evaluation extracts the section over `V`.
  let eY : GV.obj ((SheafOfModules.forget X.ringCatSheaf ⋙
        PresheafOfModules.restrictScalars α).obj F) ≅
      ((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj (Opposite.op V) := Iso.refl _
  -- (compat) The evaluated Čech augmentation equals the canonical `sectionCechAugV` read through
  -- `coreIso_objIso 0`; definitional, since `sectionCechAugV` is by construction
  -- `GV(Ψ(cechAugmentation)) ≫ (coreIso_objIso 𝒰 F 0 V).hom` and `eY.hom = 𝟙`.
  have hcompat : GV.map ((SheafOfModules.forget X.ringCatSheaf ⋙
        PresheafOfModules.restrictScalars α).map (cechAugmentation 𝒰 F)) ≫
        (HomologicalComplex.Hom.isoApp coreIso 0).hom = eY.hom ≫ sectionCechAugV 𝒰 F V := by
    have happ : (HomologicalComplex.Hom.isoApp coreIso 0).hom = (coreIso_objIso 𝒰 F 0 V).hom :=
      congrArg Iso.hom (HomologicalComplex.Hom.isoOfComponents_app _ _ 0)
    rw [happ, sectionCechAugV]
    exact (Category.id_comp _).symm
  -- Peel the augmentation node off `D` with `mapHC_augment_iso` (twice), then glue the
  -- non-augmented `coreIso` to the augmentation data with `augmentCochainIso`.
  exact (GV.mapHomologicalComplex cc).mapIso
      (mapHC_augment_iso (SheafOfModules.forget X.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars α) hΨadd (cechComplexOnX 𝒰 F) (cechAugmentation 𝒰 F)
        (cechAugmentation_comp_d 𝒰 F)) ≪≫
    mapHC_augment_iso GV ‹GV.Additive› (((SheafOfModules.forget X.ringCatSheaf ⋙
        PresheafOfModules.restrictScalars α).mapHomologicalComplex cc).obj (cechComplexOnX 𝒰 F))
      ((SheafOfModules.forget X.ringCatSheaf ⋙
        PresheafOfModules.restrictScalars α).map (cechAugmentation 𝒰 F))
      (map_augment_cond (SheafOfModules.forget X.ringCatSheaf ⋙
        PresheafOfModules.restrictScalars α) hΨadd (cechComplexOnX 𝒰 F) (cechAugmentation 𝒰 F)
        (cechAugmentation_comp_d 𝒰 F)) ≪≫
    augmentCochainIso coreIso eY (GV.map ((SheafOfModules.forget X.ringCatSheaf ⋙
        PresheafOfModules.restrictScalars α).map (cechAugmentation 𝒰 F)))
      (map_augment_cond GV ‹GV.Additive› (((SheafOfModules.forget X.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars α).mapHomologicalComplex cc).obj (cechComplexOnX 𝒰 F))
        ((SheafOfModules.forget X.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars α).map (cechAugmentation 𝒰 F))
        (map_augment_cond (SheafOfModules.forget X.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars α) hΨadd (cechComplexOnX 𝒰 F) (cechAugmentation 𝒰 F)
          (cechAugmentation_comp_d 𝒰 F))) (sectionCechAugV 𝒰 F V)
      (sectionCechAugV_comp_d 𝒰 F V) hcompat


end AlgebraicGeometry
