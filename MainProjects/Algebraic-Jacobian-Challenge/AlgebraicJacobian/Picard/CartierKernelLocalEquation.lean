/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.GrassmannianQuot

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry.Scheme.CartierKernel

variable {X : Scheme.{u}} {E F : X.Modules}

/-- The equation determined by trivializations of a quotient source and kernel. -/
noncomputable def localEquation (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : Limits.kernel q ≅ SheafOfModules.unit X.ringCatSheaf) : Γ(X, ⊤) :=
  (eI.inv ≫ Limits.kernel.ι q ≫ eO.hom).val.app (op ⊤)
    (1 : X.ringCatSheaf.obj.obj (op ⊤))

lemma localEquation_scalar (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : Limits.kernel q ≅ SheafOfModules.unit X.ringCatSheaf) :
    Grassmannian.scalarEnd (localEquation q eO eI) =
      eI.inv ≫ Limits.kernel.ι q ≫ eO.hom := by
  let j := eI.inv ≫ Limits.kernel.ι q ≫ eO.hom
  apply (SheafOfModules.unit X.ringCatSheaf).unitHomEquiv.injective
  rw [Grassmannian.unitHomEquiv_scalarEnd]
  refine PresheafOfModules.sections_ext _ _ (fun V => ?_)
  change _ = j.val.app V (1 : X.ringCatSheaf.obj.obj V)
  change X.ringCatSheaf.obj.map (homOfLE le_top).op
      (j.val.app (op ⊤) (1 : X.ringCatSheaf.obj.obj (op ⊤))) =
    j.val.app V (1 : X.ringCatSheaf.obj.obj V)
  have hnat := PresheafOfModules.naturality_apply j.val
    (homOfLE (le_top : V.unop ≤ ⊤)).op
    (1 : X.ringCatSheaf.obj.obj (op ⊤))
  exact hnat.symm.trans (congrArg (fun z => j.val.app V z)
    (PresheafOfModules.unit_map_one X.ringCatSheaf.obj
      (homOfLE (le_top : V.unop ≤ ⊤)).op))

lemma localEquation_apply_of_scalar (q : E ⟶ F)
    (eO : E ≅ SheafOfModules.unit X.ringCatSheaf)
    (eI : Limits.kernel q ≅ SheafOfModules.unit X.ringCatSheaf)
    (hscalar : Grassmannian.scalarEnd (localEquation q eO eI) =
      eI.inv ≫ Limits.kernel.ι q ≫ eO.hom)
    (U : X.Opens) (s : X.ringCatSheaf.obj.obj (op U)) :
    ((eI.inv ≫ Limits.kernel.ι q ≫ eO.hom).val.app (op U)) s =
      s * X.ringCatSheaf.obj.map (homOfLE (show U ≤ ⊤ from le_top)).op
      (localEquation q eO eI) := by
  let j := eI.inv ≫ Limits.kernel.ι q ≫ eO.hom
  change j.val.app (op U) s = _
  dsimp [j] at hscalar ⊢
  rw [← hscalar]
  exact Grassmannian.scalarEnd_val_app _ _ _

end AlgebraicGeometry.Scheme.CartierKernel
