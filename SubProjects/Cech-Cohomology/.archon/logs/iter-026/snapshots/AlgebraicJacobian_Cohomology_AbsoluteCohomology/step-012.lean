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

/-- The standard `HasExt` structure on `X.Modules`, made a section-local instance so the
`Ext`-based absolute cohomology below resolves it without the slow `HasSmallLocalizedHom`
typeclass search. -/
noncomputable local instance hasExtModules : HasExt.{u + 1, u, u + 1} X.Modules :=
  HasExt.standard _

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
    (F : X.Modules) : AddCommGrpCat :=
  AddCommGrpCat.of (Ext (jShriekOU U) F p)

/-- **`H⁰(U, F) ≅ Γ(U, F)`** as abelian groups: degree-zero `Ext` out of the
corepresenting object `jShriekOU U` recovers the sections of `F` over `U`. This is the
additive corepresentability of global sections specialised to `p = 0`. -/
noncomputable def absoluteCohomologyZeroAddEquiv (U : TopologicalSpace.Opens X)
    (F : X.Modules) :
    Ext (jShriekOU U) F 0 ≃+
      ((Scheme.Modules.toPresheafOfModules X).obj F).presheaf.obj (Opposite.op U) :=
  (AddEquiv.mk' Ext.homEquiv₀ (by
    intro a b
    refine Ext.homEquiv₀.symm.injective ?_
    simp only [Equiv.symm_apply_apply, Ext.homEquiv₀_symm_apply, Ext.mk₀_add])).trans
    (jShriekOU_homEquiv U F)

/-- **Injective vanishing**: positive-degree absolute cohomology of an injective sheaf of
modules vanishes. Direct from `Ext.eq_zero_of_injective` (the injective object is the
*second* `Ext` argument, so no restriction of the coefficient sheaf is needed). -/
theorem absoluteCohomology_eq_zero_of_injective (n : ℕ) (U : TopologicalSpace.Opens X)
    (I : X.Modules) [Injective I] (e : Ext (jShriekOU U) I (n + 1)) : e = 0 :=
  Ext.eq_zero_of_injective e

end AlgebraicGeometry
