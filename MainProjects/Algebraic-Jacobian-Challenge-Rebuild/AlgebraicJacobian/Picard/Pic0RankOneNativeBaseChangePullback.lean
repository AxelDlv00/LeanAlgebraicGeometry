/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.Pic0RankOneLocusNative
import AlgebraicJacobian.Cohomology.GluedSheafDatumBaseChange

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

/-- The component of the datum sections comparison on an arbitrary open. -/
noncomputable def nativeModuleSectionsMapApp (U : (relCurve C B).Opens) :
    (D.nativeModule.val.obj (op U)) ⟶
      (((Scheme.Modules.pushforward (relCurveMap C B B')).obj
        (D.baseChange B').nativeModule).val.obj (op U)) := by
  refine ModuleCat.ofHom
    { toFun := fun s ↦ D.sectionsMap B' le_rfl s
      map_add' := fun s t ↦ D.sectionsMap_add B' le_rfl s t
      map_smul' := fun r s ↦ ?_ }
  change D.sectionsMap B' le_rfl
      (gluedQsmul B D.pieces D.unit le_rfl r s) =
    gluedQsmul B' (D.baseChange B').pieces (D.baseChange B').unit le_rfl
      (((relCurveMap C B B').app U).hom r) (D.sectionsMap B' le_rfl s)
  simpa only [Scheme.Hom.appLE_eq_app] using
    D.sectionsMap_gluedQsmul B'
      (W := U) (W' := relCurveMap C B B' ⁻¹ᵁ U)
      (V := U) (V' := relCurveMap C B B' ⁻¹ᵁ U)
      le_rfl le_rfl le_rfl le_rfl r s

/-- `sectionsMap`, assembled as an `O_{C_B}`-linear map into pushforward. -/
noncomputable def nativeModuleSectionsMap :
    D.nativeModule ⟶
      (Scheme.Modules.pushforward (relCurveMap C B B')).obj
        (D.baseChange B').nativeModule where
  val :=
    { app := fun U ↦ D.nativeModuleSectionsMapApp B' U.unop
      naturality := fun {U V} i ↦ by
        apply ModuleCat.hom_ext
        apply LinearMap.ext
        intro s
        change D.sectionsMap B' le_rfl
            (gluedRes B D.pieces D.unit i.unop.le s) =
          gluedRes B' (D.baseChange B').pieces (D.baseChange B').unit
            (Scheme.Hom.preimage_mono (relCurveMap C B B') i.unop.le)
            (D.sectionsMap B' le_rfl s)
        exact (D.gluedRes_sectionsMap B' i.unop.le le_rfl le_rfl
          (Scheme.Hom.preimage_mono (relCurveMap C B B') i.unop.le) s).symm }

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

end

end BasicOpenCocycleDatum

end AlgebraicGeometry
