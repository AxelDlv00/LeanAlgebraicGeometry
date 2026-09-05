/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DivisorModuleFiber

/-!
# Local-ring linearity of the divisor-module stalk value

The additive stalk value map lands in the function field.  This file records
the stronger local-ring linearity that follows from the structure-sheaf action,
without choosing a uniformizer or a residue-field coordinate.
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

/-- The stalk value map is linear over the local structure ring. -/
noncomputable def stalkValLinearMap (D : CurveDivisor k X) (x : X.left) :
    letI : Module (X.left.presheaf.stalk x) (Scheme.Modules.Stalk (divisorModule D) x) :=
      Scheme.Modules.stalkModule (divisorModule D) x
    Scheme.Modules.Stalk (divisorModule D) x →ₗ[X.left.presheaf.stalk x]
      X.left.functionField := by
  letI : Module (X.left.presheaf.stalk x) (Scheme.Modules.Stalk (divisorModule D) x) :=
    Scheme.Modules.stalkModule (divisorModule D) x
  exact
    { toFun := stalkVal D x
      map_add' := map_add (stalkVal D x)
      map_smul' := by
        intro r m
        rw [Algebra.smul_def]
        obtain ⟨U, hxU, r₀, rfl⟩ :=
          TopCat.Presheaf.exists_germ_eq X.left.presheaf r
        obtain ⟨V, hxV, s₀, rfl⟩ :=
          TopCat.Presheaf.exists_germ_eq (divisorModule D).val.presheaf m
        let W : X.left.Opens := U ⊓ V
        have hxW : x ∈ W := ⟨hxU, hxV⟩
        let iWU : W ⟶ U := homOfLE inf_le_left
        let iWV : W ⟶ V := homOfLE inf_le_right
        let rW : Γ(X.left, W) := (X.left.presheaf.map iWU.op).hom r₀
        let sW : (divisorModule D).val.presheaf.obj (op W) :=
          (divisorModule D).val.presheaf.map iWV.op s₀
        have hr :
            ConcreteCategory.hom (X.left.presheaf.germ U x hxU) r₀ =
              ConcreteCategory.hom (X.left.presheaf.germ W x hxW) rW := by
          exact (TopCat.Presheaf.germ_res_apply
            X.left.presheaf iWU x hxW r₀).symm
        have hs :
            ConcreteCategory.hom
                (TopCat.Presheaf.germ (divisorModule D).val.presheaf V x hxV) s₀ =
              ConcreteCategory.hom
                (TopCat.Presheaf.germ (divisorModule D).val.presheaf W x hxW) sW := by
          exact (TopCat.Presheaf.germ_res_apply
            (divisorModule D).val.presheaf iWV x hxW s₀).symm
        rw [hr, hs]
        letI : Module (X.left.ringCatSheaf.obj.obj (op W))
            ((divisorAbPresheaf D).obj (op W)) :=
          divisorSectionsModule D W
        set_option backward.defeqAttrib.useBackward true in
        set_option backward.isDefEq.respectTransparency false in
        have hsmul := PresheafOfModules.germ_smul
          (M := (divisorModule D).val) x W hxW
            (rW : X.left.sheaf.presheaf.obj (op W)) sW
        have hsmul' :
            ConcreteCategory.hom
                (TopCat.Presheaf.germ (divisorModule D).val.presheaf W x hxW)
                (divisorSectionAction D W rW (show divisorSections D W from sW)) =
              ConcreteCategory.hom (X.left.presheaf.germ W x hxW) rW •
                ConcreteCategory.hom
                  (TopCat.Presheaf.germ (divisorModule D).val.presheaf W x hxW) sW := by
          set_option backward.defeqAttrib.useBackward true in
          set_option backward.isDefEq.respectTransparency false in
          exact hsmul
        rw [← hsmul']
        rw [stalkVal_germ, stalkVal_germ]
        have hW : (W : Set X.left).Nonempty := ⟨x, hxW⟩
        rw [divisorSectionAction_coe_of_nonempty D W hW]
        rw [germ_generic_eq_algebraMap_germ
          (genericPoint_mem_of_nonempty hW) hxW rW]
        simp only [RingHom.id_apply] }

end
end Hartshorne
