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

/-- The sheafification adjunction hom-bijection as an `AddEquiv` (additivity holds because
the right adjoint is an additive functor and composition is bilinear). -/
noncomputable def sheafificationHomAddEquiv (U : TopologicalSpace.Opens X) (F : X.Modules) :
    (jShriekOU U ⟶ F) ≃+
      ((PresheafOfModules.free X.ringCatSheaf.obj).obj (yoneda.obj U) ⟶
        (Scheme.Modules.toPresheafOfModules X).obj F) :=
  { (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).homEquiv
      ((PresheafOfModules.free X.ringCatSheaf.obj).obj (yoneda.obj U)) F with
    map_add' := by
      intro f g
      haveI : (SheafOfModules.forget X.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)).Additive := inferInstance
      simp only [Equiv.toFun_as_coe, Adjunction.homEquiv_unit]
      erw [Functor.map_add, Preadditive.comp_add]
      rfl }

noncomputable def jShriekOU_homEquiv (U : TopologicalSpace.Opens X) (F : X.Modules) :
    (jShriekOU U ⟶ F) ≃+
      ((Scheme.Modules.toPresheafOfModules X).obj F).presheaf.obj (Opposite.op U) :=
  (sheafificationHomAddEquiv U F).trans (freeYonedaHomAddEquiv U _)

/-- **Form-B absolute cohomology** `H^p(U, F) := Ext^p_{O_X}(jShriekOU U, F)`. -/
noncomputable def absoluteCohomology (p : ℕ) (U : TopologicalSpace.Opens X)
    (F : X.Modules) : AddCommGrp.{u} :=
  letI := HasExt.standard X.Modules
  AddCommGrp.of (Ext (jShriekOU U) F p)

end AlgebraicGeometry
