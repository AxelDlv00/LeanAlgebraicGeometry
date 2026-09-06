/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.DivisorSheafQcoh
import AlgebraicJacobian.RiemannRoch.Ledger.FiberBound
import AlgebraicJacobian.Cohomology.StructureSheafModuleK.QuasicoherentDegreeOneVanishing

/-!
# Divisor sheaves as modules over the structure sheaf

The regular-function action on bounded rational functions constructs an object
of `Scheme.Modules`. Its underlying sheaf of vector spaces is the existing
`Scheme.divisorSheaf`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace AlgebraicGeometry.Scheme

attribute [local instance] functionFieldOverModule overModule

variable (K : Type u) [Field K] {X : Scheme.{u}}
  [X.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
  [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (X ↘ Spec (CommRingCat.of K))]

lemma divisorVal_qsmul {D : X.CurveDivisor} {U W : X.Opens}
    (hU : genericPoint X ∈ U) (hWU : W ≤ U) (r : Γ(X, U))
    (s : (X.divisorSheaf K D).obj.obj (op W)) :
    divisorVal K (QcohOn.qsmul (F := X.divisorSheaf K D) hWU r s) =
      (X.presheaf.germ U (genericPoint X) hU).hom r * divisorVal K s := by
  unfold divisorSheaf.instQcohOn
  rw [dif_pos hU]
  rfl

/-- The section-ring module structure comes from multiplication of rational functions. -/
@[reducible] noncomputable def divisorSectionsModule (D : X.CurveDivisor)
    (U : X.Opensᵒᵖ) : Module (X.presheaf.obj U) ((X.divisorSheaf K D).obj.obj U) where
  smul := QcohOn.qsmul le_rfl
  one_smul := QcohOn.one_qsmul le_rfl
  mul_smul := QcohOn.mul_qsmul le_rfl
  smul_add := QcohOn.qsmul_add le_rfl
  add_smul := QcohOn.add_qsmul le_rfl
  smul_zero := QcohOn.qsmul_zero le_rfl
  zero_smul s := by
    have h := QcohOn.add_qsmul (F := X.divisorSheaf K D) (U := U.unop) le_rfl 0 0 s
    rw [add_zero] at h
    exact (add_left_cancel (h.symm.trans (add_zero _).symm))

attribute [local instance] divisorSectionsModule

/-- Restricting the ambient regular function gives the same action on a smaller open. -/
lemma divisorSheaf_qsmul_restrict {D : X.CurveDivisor} {U V : X.Opens}
    (hVU : V ≤ U) (r : Γ(X, U)) (s : (X.divisorSheaf K D).obj.obj (op V)) :
    QcohOn.qsmul (F := X.divisorSheaf K D) hVU r s =
      QcohOn.qsmul (F := X.divisorSheaf K D) le_rfl (X.resHom hVU r) s := by
  by_cases hV : (V : Set X).Nonempty
  · have hηV := genericPoint_mem_of_nonempty hV
    apply divisorSection_ext K
    rw [divisorVal_qsmul K (hVU hηV), divisorVal_qsmul K hηV]
    congr 1
    exact (X.presheaf.germ_res_apply (homOfLE hVU) (genericPoint X) hηV r).symm
  · haveI : Subsingleton ((X.divisorSheaf K D).obj.obj (op V)) :=
      divisorPresheaf_obj_subsingleton K (D := D) hV
    exact Subsingleton.elim _ _

/-- Divisor-section restrictions are semilinear over restrictions of regular functions. -/
lemma divisorSheaf_map_smul {D : X.CurveDivisor} {U V : X.Opensᵒᵖ}
    (f : U ⟶ V) (r : Γ(X, U.unop)) (s : (X.divisorSheaf K D).obj.obj U) :
    (X.divisorSheaf K D).obj.map f (r • s) =
      (X.presheaf.map f r) • (X.divisorSheaf K D).obj.map f s := by
  change secRes (X.divisorSheaf K D) f.unop.le (QcohOn.qsmul le_rfl r s) =
    QcohOn.qsmul le_rfl (X.resHom f.unop.le r)
      (secRes (X.divisorSheaf K D) f.unop.le s)
  rw [QcohOn.secRes_qsmul, divisorSheaf_qsmul_restrict]

/-- The sheaf `O(D)` with its regular-function action, as an actual `O_X`-module. -/
noncomputable def divisorModules (D : X.CurveDivisor) : X.Modules := by
  letI (U : X.Opensᵒᵖ) : Module (X.ringCatSheaf.obj.obj U)
      (((X.divisorSheaf K D).obj ⋙ forget₂ (ModuleCat K) AddCommGrpCat).obj U) :=
    divisorSectionsModule K D U
  exact
    { val := PresheafOfModules.ofPresheaf
        ((X.divisorSheaf K D).obj ⋙ forget₂ (ModuleCat K) AddCommGrpCat)
        (fun {_ _} f r s => divisorSheaf_map_smul K (D := D) f r s)
      isSheaf := ((sheafCompose (Opens.grothendieckTopology X.toTopCat)
        (forget₂ (ModuleCat.{u} K) AddCommGrpCat.{u})).obj
        (X.divisorSheaf K D)).property }

noncomputable section FieldComparison

variable (C : Over (Spec (CommRingCat.of K)))
  [SmoothOfRelativeDimension 1 C.hom] [IsIntegral C.left]
  [LocallyOfFiniteType C.hom] [QuasiCompact C.hom]

local instance : C.left.Over (Spec (CommRingCat.of K)) := .ofHom C.hom

local instance : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of K)) :=
  inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)

local instance : LocallyOfFiniteType (C.left ↘ Spec (CommRingCat.of K)) :=
  inferInstanceAs (LocallyOfFiniteType C.hom)

local instance : QuasiCompact (C.left ↘ Spec (CommRingCat.of K)) :=
  inferInstanceAs (QuasiCompact C.hom)

attribute [local instance] moduleKSections

/-- Restriction of the regular-function action to constants recovers the original field action. -/
noncomputable def divisorModulesFieldSectionsEquiv (D : C.left.CurveDivisor)
    (U : C.left.Opens) :
    Γ(divisorModules K D, U) ≃ₗ[K] (C.left.divisorSheaf K D).obj.obj (op U) where
  toFun s := s
  invFun s := s
  left_inv _ := rfl
  right_inv _ := rfl
  map_add' _ _ := rfl
  map_smul' r s := by
    by_cases hU : (U : Set C.left).Nonempty
    · apply divisorSection_ext K
      change divisorVal K (QcohOn.qsmul (F := C.left.divisorSheaf K D) le_rfl
        ((toModuleKSheaf.kToSection C (op U)).hom r) s) =
          functionFieldOverAlgebraMap K C.left r * divisorVal K s
      rw [divisorVal_qsmul K (genericPoint_mem_of_nonempty hU)]
      change (C.left.presheaf.germ U (genericPoint C.left)
        (genericPoint_mem_of_nonempty hU)).hom (C.left.overAlgebraMap K U r) *
          divisorVal K s = functionFieldOverAlgebraMap K C.left r * divisorVal K s
      rw [germ_generic_overAlgebraMap]
    · haveI : Subsingleton ((C.left.divisorSheaf K D).obj.obj (op U)) :=
        divisorPresheaf_obj_subsingleton K (D := D) hU
      exact Subsingleton.elim _ _

/-- The constructed structure-sheaf module has the original divisor sheaf as its field sheaf. -/
noncomputable def divisorModulesFieldSheafIso (D : C.left.CurveDivisor) :
    toModuleKSheafOfModules C (divisorModules K D) ≅ C.left.divisorSheaf K D :=
  ObjectProperty.isoMk _ (NatIso.ofComponents
    (fun U => (divisorModulesFieldSectionsEquiv K C D U.unop).toModuleIso)
    (fun _ => by ext s; rfl))

/-- The degree bound for the divisor sheaf is valid for the constructed `O_X`-module. -/
theorem exists_bound_hModule_one_divisorModules_of_isFinite_toP1
    [Module.Finite K (Sheaf.HModule (C.left.moduleKSheaf K) 0)]
    (π : C.left ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = C.hom) :
    ∃ b : ℤ, ∀ D : C.left.CurveDivisor, b ≤ CurveDivisor.deg K D →
      Subsingleton (Sheaf.HModule
        (toModuleKSheafOfModules C (divisorModules K D)) 1) := by
  obtain ⟨b, hb⟩ := exists_bound_subsingleton_hModule_one_of_isFinite_toP1 π hπ
  refine ⟨b, fun D hD => ?_⟩
  exact (Equiv.subsingleton_congr
    (Sheaf.HModule.mapEquiv (divisorModulesFieldSheafIso K C D) 1).toEquiv).mpr (hb D hD)

end FieldComparison

end AlgebraicGeometry.Scheme
