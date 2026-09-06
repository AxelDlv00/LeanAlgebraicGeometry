/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter2LineBundleAPI
import HartshorneLib.Chapter4DivisorSheafZero

/-!
# The divisor sheaf as a scheme module

The bounded rational functions defining `divisorSheaf D` are stable under
multiplication by regular functions.  This file packages that action as an
actual `O_X`-module.  Its underlying additive presheaf is the one underlying
the existing `k`-module-valued divisor sheaf.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

attribute [local instance] functionFieldOverModule Scheme.overModule

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

/-! ## The structure-sheaf action -/

open Classical in
/-- A regular function acts on a bounded rational section through its germ at
the generic point.  On the empty open the section space is the zero module. -/
noncomputable def divisorSectionAction (D : CurveDivisor k X) (U : X.left.Opens)
    (r : Γ(X.left, U)) (s : divisorSections D U) : divisorSections D U :=
  if hU : (U : Set X.left).Nonempty then
    letI : Nonempty U := by simpa using hU
    ⟨(X.left.germToFunctionField U).hom r * (s : X.left.functionField), by
      apply (mem_divisorSections_of_nonempty hU).mpr
      intro x hx hxU
      rw [map_mul]
      have hr :
          orderAt X.hom hx ((X.left.germToFunctionField U).hom r) ≤ 1 := by
        rw [germ_generic_eq_algebraMap_germ
          (genericPoint_mem_of_nonempty hU) hxU r]
        exact orderAt_algebraMap_stalk_le_one hx _
      calc
        orderAt X.hom hx ((X.left.germToFunctionField U).hom r) *
              orderAt X.hom hx (s : X.left.functionField)
            ≤ 1 * orderAt X.hom hx (s : X.left.functionField) := by
              gcongr
        _ = orderAt X.hom hx (s : X.left.functionField) := one_mul _
        _ ≤ divisorBound D hx :=
          (mem_divisorSections_of_nonempty hU).mp s.2 x hx hxU⟩
  else 0

lemma divisorSectionAction_coe_of_nonempty (D : CurveDivisor k X)
    (U : X.left.Opens) (hU : (U : Set X.left).Nonempty)
    (r : Γ(X.left, U)) (s : divisorSections D U) :
    ((divisorSectionAction D U r s : divisorSections D U) : X.left.functionField) =
      letI : Nonempty U := by simpa using hU
      (X.left.germToFunctionField U).hom r * (s : X.left.functionField) := by
  rw [divisorSectionAction, dif_pos hU]

lemma divisorSectionAction_of_empty (D : CurveDivisor k X)
    (U : X.left.Opens) (hU : ¬ (U : Set X.left).Nonempty)
    (r : Γ(X.left, U)) (s : divisorSections D U) :
    divisorSectionAction D U r s = 0 := by
  classical
  rw [divisorSectionAction, dif_neg hU]

open Classical in
@[reducible] noncomputable def divisorSectionsModule
    (D : CurveDivisor k X) (U : X.left.Opens) :
    Module Γ(X.left, U) (divisorSections D U) where
  smul := divisorSectionAction D U
  one_smul s := by
    change divisorSectionAction D U 1 s = s
    by_cases hU : (U : Set X.left).Nonempty
    · apply Subtype.ext
      rw [divisorSectionAction_coe_of_nonempty D U hU, map_one, one_mul]
    · letI := divisorSections_subsingleton_of_empty (D := D) hU
      exact Subsingleton.elim _ _
  mul_smul r t s := by
    change divisorSectionAction D U (r * t) s =
      divisorSectionAction D U r (divisorSectionAction D U t s)
    by_cases hU : (U : Set X.left).Nonempty
    · apply Subtype.ext
      rw [divisorSectionAction_coe_of_nonempty D U hU,
        divisorSectionAction_coe_of_nonempty D U hU,
        divisorSectionAction_coe_of_nonempty D U hU, map_mul, mul_assoc]
    · letI := divisorSections_subsingleton_of_empty (D := D) hU
      exact Subsingleton.elim _ _
  smul_zero r := by
    change divisorSectionAction D U r 0 = 0
    by_cases hU : (U : Set X.left).Nonempty
    · apply Subtype.ext
      rw [divisorSectionAction_coe_of_nonempty D U hU]
      exact mul_zero _
    · exact divisorSectionAction_of_empty D U hU r 0
  smul_add r s t := by
    change divisorSectionAction D U r (s + t) =
      divisorSectionAction D U r s + divisorSectionAction D U r t
    by_cases hU : (U : Set X.left).Nonempty
    · letI : Nonempty U := by simpa using hU
      apply Subtype.ext
      rw [divisorSectionAction_coe_of_nonempty D U hU]
      calc
        _ = (X.left.germToFunctionField U).hom r * (s : X.left.functionField) +
              (X.left.germToFunctionField U).hom r * (t : X.left.functionField) :=
          mul_add _ _ _
        _ = ((divisorSectionAction D U r s : divisorSections D U) :
                X.left.functionField) +
              ((divisorSectionAction D U r t : divisorSections D U) :
                X.left.functionField) := by
          rw [divisorSectionAction_coe_of_nonempty D U hU,
            divisorSectionAction_coe_of_nonempty D U hU]
        _ = _ := rfl
    · letI := divisorSections_subsingleton_of_empty (D := D) hU
      exact Subsingleton.elim _ _
  add_smul r t s := by
    change divisorSectionAction D U (r + t) s =
      divisorSectionAction D U r s + divisorSectionAction D U t s
    by_cases hU : (U : Set X.left).Nonempty
    · letI : Nonempty U := by simpa using hU
      apply Subtype.ext
      rw [divisorSectionAction_coe_of_nonempty D U hU, map_add]
      calc
        _ = (X.left.germToFunctionField U).hom r * (s : X.left.functionField) +
              (X.left.germToFunctionField U).hom t * (s : X.left.functionField) :=
          add_mul _ _ _
        _ = ((divisorSectionAction D U r s : divisorSections D U) :
                X.left.functionField) +
              ((divisorSectionAction D U t s : divisorSections D U) :
                X.left.functionField) := by
          rw [divisorSectionAction_coe_of_nonempty D U hU,
            divisorSectionAction_coe_of_nonempty D U hU]
        _ = _ := rfl
    · letI := divisorSections_subsingleton_of_empty (D := D) hU
      exact Subsingleton.elim _ _
  zero_smul s := by
    change divisorSectionAction D U 0 s = 0
    by_cases hU : (U : Set X.left).Nonempty
    · apply Subtype.ext
      rw [divisorSectionAction_coe_of_nonempty D U hU, map_zero, zero_mul]
      rfl
    · exact divisorSectionAction_of_empty D U hU 0 s

/-- The structure-sheaf action restricts along the base-field map to the
existing `k`-module structure on bounded rational sections. -/
lemma divisorSectionAction_overAlgebraMap (D : CurveDivisor k X)
    (U : X.left.Opens) (r : k) (s : divisorSections D U) :
    divisorSectionAction D U (X.left.overAlgebraMap k U r) s = r • s := by
  classical
  by_cases hU : (U : Set X.left).Nonempty
  · apply Subtype.ext
    rw [divisorSectionAction_coe_of_nonempty D U hU,
      germ_generic_overAlgebraMap (genericPoint_mem_of_nonempty hU),
      SetLike.val_smul, functionFieldOverModule_smul_def]
  · letI := divisorSections_subsingleton_of_empty (D := D) hU
    exact Subsingleton.elim _ _

/-- Restriction of bounded rational sections is semilinear for restriction of
regular functions. -/
lemma divisorSectionsRes_action {D : CurveDivisor k X}
    {U V : (X.left.Opens)ᵒᵖ} (i : U ⟶ V)
    (r : Γ(X.left, U.unop)) (s : divisorSections D U.unop) :
    divisorSectionsRes D (leOfHom i.unop)
        (divisorSectionAction D U.unop r s) =
      divisorSectionAction D V.unop ((X.left.presheaf.map i).hom r)
        (divisorSectionsRes D (leOfHom i.unop) s) := by
  classical
  by_cases hV : (V.unop : Set X.left).Nonempty
  · have hU : (U.unop : Set X.left).Nonempty := hV.mono (leOfHom i.unop)
    apply Subtype.ext
    rw [divisorSectionsRes_coe (leOfHom i.unop) hV,
      divisorSectionAction_coe_of_nonempty D U.unop hU,
      divisorSectionAction_coe_of_nonempty D V.unop hV,
      divisorSectionsRes_coe (leOfHom i.unop) hV]
    letI : Nonempty U.unop := by simpa using hU
    letI : Nonempty V.unop := by simpa using hV
    have hres := X.left.presheaf.germ_res_apply i.unop (genericPoint X.left)
      (genericPoint_mem_of_nonempty hV) r
    have hres' :
        (X.left.germToFunctionField V.unop).hom
            ((X.left.presheaf.map i).hom r) =
          (X.left.germToFunctionField U.unop).hom r := by
      simpa using hres
    rw [hres']
  · letI := divisorSections_subsingleton_of_empty (D := D) hV
    exact Subsingleton.elim _ _

/-! ## The presheaf and scheme module -/

@[reducible] noncomputable def divisorAbPresheaf (D : CurveDivisor k X) :
    X.left.Opensᵒᵖ ⥤ AddCommGrpCat.{u} where
  obj U := AddCommGrpCat.of (divisorSections D U.unop)
  map {U V} i := AddCommGrpCat.ofHom
    (divisorSectionsRes D (leOfHom i.unop)).toAddMonoidHom
  map_id U := by
    apply AddCommGrpCat.hom_ext
    simp only [AddCommGrpCat.hom_ofHom, AddCommGrpCat.hom_id,
      divisorSectionsRes_id (D := D) (leOfHom (𝟙 U).unop)]
    ext s
    rfl
  map_comp {U V W} i j := by
    apply AddCommGrpCat.hom_ext
    have hcomp : divisorSectionsRes D (leOfHom (i ≫ j).unop) =
        (divisorSectionsRes D (leOfHom j.unop)).comp
          (divisorSectionsRes D (leOfHom i.unop)) :=
      divisorSectionsRes_comp (leOfHom j.unop) (leOfHom i.unop)
    simp only [AddCommGrpCat.hom_ofHom, AddCommGrpCat.hom_comp, hcomp]
    ext s
    rfl

/-- Forgetting the `k`-linear structure on `divisorPresheaf` gives the same
additive presheaf used for the structure-sheaf module. -/
noncomputable def divisorAbPresheafIso (D : CurveDivisor k X) :
    divisorAbPresheaf D ≅
      divisorPresheaf D ⋙ forget₂ (ModuleCat.{u} k) AddCommGrpCat.{u} :=
  NatIso.ofComponents (fun _ => Iso.refl _) (fun _ => rfl)

noncomputable def divisorPresheafOfModules (D : CurveDivisor k X) :
    X.left.PresheafOfModules := by
  letI divisorModuleInstances :
      ∀ W, Module (X.left.ringCatSheaf.obj.obj W) ((divisorAbPresheaf D).obj W) :=
    fun W => divisorSectionsModule D W.unop
  apply PresheafOfModules.ofPresheaf (divisorAbPresheaf D)
  rintro ⟨U⟩ ⟨V⟩ i r s
  dsimp [divisorAbPresheaf]
  change divisorSectionsRes D (leOfHom i.unop)
      (divisorSectionAction D U r s) =
    divisorSectionAction D V ((X.left.presheaf.map i).hom r)
      (divisorSectionsRes D (leOfHom i.unop) s)
  exact divisorSectionsRes_action i r s

lemma divisorPresheafOfModules_presheaf (D : CurveDivisor k X) :
    (divisorPresheafOfModules D).presheaf = divisorAbPresheaf D := by
  rw [divisorPresheafOfModules, PresheafOfModules.ofPresheaf_presheaf]

lemma isSheaf_divisorPresheafOfModules (D : CurveDivisor k X) :
    Presheaf.IsSheaf (Opens.grothendieckTopology (X.left : TopCat))
      (divisorPresheafOfModules D).presheaf := by
  rw [divisorPresheafOfModules_presheaf]
  rw [Presheaf.isSheaf_of_iso_iff (divisorAbPresheafIso D)]
  exact Presheaf.isSheaf_comp_of_isSheaf
    (Opens.grothendieckTopology (X.left : TopCat))
    (divisorPresheaf D)
    (forget₂ (ModuleCat.{u} k) AddCommGrpCat.{u})
    (isSheaf_divisorPresheaf D)

/-- The sheaf `O(D)` as an actual module over the structure sheaf. -/
noncomputable def divisorModule (D : CurveDivisor k X) : X.left.Modules where
  val := divisorPresheafOfModules D
  isSheaf := isSheaf_divisorPresheafOfModules D

lemma divisorModule_presheaf (D : CurveDivisor k X) :
    (divisorModule D).presheaf = divisorAbPresheaf D :=
  divisorPresheafOfModules_presheaf D

/-! ## The zero divisor -/

/-- The generic-point germ comparison from the structure sheaf to the
zero-divisor sheaf, promoted to a morphism of `O_X`-modules. -/
noncomputable def moduleToDivisorModuleZero :
    SheafOfModules.unit X.left.ringCatSheaf ⟶
      divisorModule (X := X) (0 : CurveDivisor k X) where
  val := PresheafOfModules.homMk
    { app := fun U => AddCommGrpCat.ofHom
        (moduleToDivisorZeroPresheafApp (X := X) U.unop).toAddMonoidHom
      naturality := fun {U V} i => by
        have h := (moduleToDivisorZeroPresheaf (X := X)).naturality i
        exact congrArg (fun f => (forget₂ (ModuleCat k) AddCommGrpCat).map f) h }
    (fun U r s => by
      change moduleToDivisorZeroPresheafApp (X := X) U.unop
          ((show Γ(X.left, U.unop) from r) *
            (show Γ(X.left, U.unop) from s)) =
        divisorSectionAction (0 : CurveDivisor k X) U.unop
          (show Γ(X.left, U.unop) from r)
          (moduleToDivisorZeroPresheafApp (X := X) U.unop
            (show Γ(X.left, U.unop) from s))
      by_cases hU : (U.unop : Set X.left).Nonempty
      · apply Subtype.ext
        rw [divisorSectionAction_coe_of_nonempty (0 : CurveDivisor k X) U.unop hU,
          moduleToDivisorZeroPresheafApp_coe_of_nonempty (X := X) hU,
          moduleToDivisorZeroPresheafApp_coe_of_nonempty (X := X) hU]
        exact map_mul _ _ _
      · letI := divisorSections_subsingleton_of_empty
          (X := X) (D := (0 : CurveDivisor k X)) hU
        exact Subsingleton.elim _ _)

/-- The divisor module of the zero divisor is the structure sheaf as an
`O_X`-module. -/
noncomputable def divisorModuleZeroIso :
    SheafOfModules.unit X.left.ringCatSheaf ≅
      divisorModule (X := X) (0 : CurveDivisor k X) := by
  letI : IsIso (moduleToDivisorModuleZero (k := k) (X := X)) := by
    apply Scheme.Modules.Hom.isIso_iff_isIso_app.mpr
    intro U
    rw [ConcreteCategory.isIso_iff_bijective]
    exact moduleToDivisorZeroPresheafApp_bijective (X := X) U
  exact asIso (moduleToDivisorModuleZero (k := k) (X := X))

/-- The zero-divisor module is a line bundle. -/
theorem isLineBundle_divisorModule_zero :
    IsLineBundle (divisorModule (X := X) (0 : CurveDivisor k X)) :=
  isLineBundle_of_iso_unit (divisorModuleZeroIso (k := k) (X := X)).symm

end

end Hartshorne
