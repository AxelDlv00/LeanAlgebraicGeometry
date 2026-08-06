/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.Pic0RankOneLocus

/-!
# The native module carried by a glued rank-one datum

`BasicOpenCocycleDatum.sheaf` is already a sheaf of modules over the coefficient
ring.  The presentation contract also asks for the same object as a sheaf of
modules over the structure sheaf of the relative curve.  This file supplies
that type-level bridge: the componentwise `gluedQsmul` action gives a module on
every open, and `gluedRes_gluedQsmul` gives the semilinearity needed by
`PresheafOfModules.ofPresheaf`.

This is deliberately only the native-module bridge.  It does not assert
`IsLineBundle`, pushforward base-change, or existence of a tied
`PicRankOneLocalPresentation`; those remain genuine producer obligations.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace AlgebraicGeometry

variable {k : Type u} [Field k]
variable {C : Over (Spec (.of k))}
variable {B : Type u} [CommRing B] [Algebra k B]
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]

namespace BasicOpenCocycleDatum

noncomputable section

variable (D : BasicOpenCocycleDatum C B pi)

/-- The structure-sheaf module on the sections of the glued datum over one open.

The action is the componentwise multiplication action; the four module laws
are inherited from the corresponding `gluedQsmul` identities. -/
@[reducible] noncomputable def moduleOn (U : (relCurve C B).Opens) :
    Module Γ(relCurve C B, U)
      ((D.sheaf.obj ⋙ (forget₂ (ModuleCat B) AddCommGrpCat)).obj (op U)) := by
  change Module Γ(relCurve C B, U)
    (↥(gluedSubmodule B D.pieces D.unit U))
  letI : SMul Γ(relCurve C B, U)
      (↥(gluedSubmodule B D.pieces D.unit U)) :=
    ⟨fun r s => gluedQsmul B D.pieces D.unit (le_rfl : U ≤ U) r s⟩
  exact Module.ofMinimalAxioms
    (fun r x y => gluedQsmul_add B D.pieces D.unit (le_rfl : U ≤ U) r x y)
    (fun r s x => gluedQsmul_add_left B D.pieces D.unit (le_rfl : U ≤ U) r s x)
    (fun r s x => gluedQsmul_mul B D.pieces D.unit (le_rfl : U ≤ U) r s x)
    (fun x => gluedQsmul_one B D.pieces D.unit (le_rfl : U ≤ U) x)

/-- The presheaf of structure-sheaf modules underlying `D`. -/
noncomputable def nativePresheaf : (relCurve C B).PresheafOfModules := by
  let M : (relCurve C B).Opensᵒᵖ ⥤ AddCommGrpCat :=
    D.sheaf.obj ⋙ (forget₂ (ModuleCat B) AddCommGrpCat)
  let family : ∀ U : (relCurve C B).Opensᵒᵖ,
      Module ((relCurve C B).ringCatSheaf.obj.obj U) (M.obj U) :=
    fun U => moduleOn D U.unop
  letI : ∀ U : (relCurve C B).Opensᵒᵖ,
      Module ((relCurve C B).ringCatSheaf.obj.obj U) (M.obj U) := family
  exact PresheafOfModules.ofPresheaf M (by
    intro X Y f r m
    change gluedRes B D.pieces D.unit f.unop.le
        (gluedQsmul B D.pieces D.unit (le_rfl : X.unop ≤ X.unop) r m) =
      gluedQsmul B D.pieces D.unit (le_rfl : Y.unop ≤ Y.unop)
        ((relCurve C B).resHom f.unop.le r)
        (gluedRes B D.pieces D.unit f.unop.le m)
    rw [gluedRes_gluedQsmul]
    apply Subtype.ext
    funext j
    rw [gluedQsmul_coe, gluedQsmul_coe]
    simp only [Scheme.resHom_resHom])

/-- The native `Scheme.Modules` object associated to a glued datum. -/
noncomputable def nativeModule : (relCurve C B).Modules := by
  refine ⟨nativePresheaf D, ?_⟩
  rw [show (nativePresheaf D).presheaf =
    D.sheaf.obj ⋙ (forget₂ (ModuleCat B) AddCommGrpCat) from rfl]
  rw [Presheaf.isSheaf_iff_isSheaf_forget _ _
    (CategoryTheory.forget AddCommGrpCat.{u})]
  convert (Presheaf.isSheaf_iff_isSheaf_forget _ _
    (CategoryTheory.forget (ModuleCat.{u} B))).mp D.sheaf.property using 1
  all_goals rfl

end

end BasicOpenCocycleDatum

end AlgebraicGeometry
