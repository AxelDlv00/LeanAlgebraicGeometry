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
that bridge: the componentwise `gluedQsmul` action gives a module on every open,
`gluedRes_gluedQsmul` gives the semilinearity needed by
`PresheafOfModules.ofPresheaf`, and `gluedQsmul_overAlgebraMap` identifies its
restriction to the coefficient ring with the original datum sheaf.

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

/-- On every open, restricting `D.nativeModule` to the coefficient ring recovers
the datum's original module of sections.

The equivalence is the identity on sections. Its linearity is the substantive
point: `gluedQsmul_overAlgebraMap` identifies the native structure-sheaf action
of a coefficient scalar with the datum's coefficient action. -/
noncomputable def nativeModuleKSectionsEquiv
    (U : (relCurve C B).Opens) :
    (Scheme.toModuleKSheafOfModules
      (Over.mk (relCurve C B ↘ Spec (.of B))) (nativeModule D)).obj.obj (op U) ≃ₗ[B]
      D.sheaf.obj.obj (op U) := by
  let f :
      (Scheme.toModuleKSheafOfModules
        (Over.mk (relCurve C B ↘ Spec (.of B))) (nativeModule D)).obj.obj (op U) →ₗ[B]
        D.sheaf.obj.obj (op U) :=
    { toFun := fun x => x
      map_add' := by
        intros
        rfl
      map_smul' := by
        intro r x
        change gluedQsmul B D.pieces D.unit (le_rfl : U ≤ U)
            ((relCurve C B).overAlgebraMap B U r) x =
          r • (show D.sheaf.obj.obj (op U) from x)
        exact gluedQsmul_overAlgebraMap B D.pieces D.unit
          (le_rfl : U ≤ U) r x }
  exact LinearEquiv.ofBijective f ⟨fun _ _ h => h, fun y => ⟨y, rfl⟩⟩

/-- The base-ring sheaf of `D.nativeModule` is canonically the datum sheaf.

This has exactly the type of `PicRankOneLocalPresentation.module_iso` when the
presentation's native module is chosen to be `D.nativeModule`. -/
noncomputable def nativeModuleKSheafIso :
    Scheme.toModuleKSheafOfModules
      (Over.mk (relCurve C B ↘ Spec (.of B))) (nativeModule D) ≅ D.sheaf :=
  (fullyFaithfulSheafToPresheaf _ _).preimageIso
    (NatIso.ofComponents
      (fun U => (nativeModuleKSectionsEquiv D U.unop).toModuleIso)
      (fun {_ _} _ => by
        apply ModuleCat.hom_ext
        apply LinearMap.ext
        intro x
        rfl))

end

end BasicOpenCocycleDatum

end AlgebraicGeometry
