/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.PresheafCech
import AlgebraicJacobian.Cohomology.FreePresheafComplex

/-!
# Form-B absolute cohomology `H^p(U, F) := Ext^p(jShriekOU U, F)` (P5b input)
-/

universe u

open CategoryTheory Limits CategoryTheory.Abelian

namespace AlgebraicGeometry

variable {X : Scheme.{u}}

/-! ## Project-local Mathlib supplement — Form-B absolute cohomology -/

noncomputable def jShriekOU (U : TopologicalSpace.Opens X) : X.Modules :=
  (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj
    ((PresheafOfModules.free X.ringCatSheaf.obj).obj (yoneda.obj U))

noncomputable def jShriekOU_homEquiv (U : TopologicalSpace.Opens X) (F : X.Modules) :
    (jShriekOU U ⟶ F) ≃+
      ((Scheme.Modules.toPresheafOfModules X).obj F).presheaf.obj (Opposite.op U) :=
  { ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).homEquiv
        ((PresheafOfModules.free X.ringCatSheaf.obj).obj (yoneda.obj U)) F).trans
      (freeYonedaHomAddEquiv U _).toEquiv with
    map_add' := by
      intro f g
      simp only [Equiv.trans_apply, AddEquiv.toEquiv_eq_coe, Equiv.coe_fn_mk,
        EquivLike.coe_coe, Adjunction.homEquiv_unit, Functor.map_add,
        Preadditive.comp_add, map_add] }

end AlgebraicGeometry
