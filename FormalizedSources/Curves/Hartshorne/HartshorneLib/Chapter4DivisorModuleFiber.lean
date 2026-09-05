/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4SchemeModuleFiber
import HartshorneLib.Chapter4DivisorModule
import HartshorneLib.Chapter4DivisorDevissageExact

/-!
# The divisor-module stalk and the local jump

The bounded rational functions defining a divisor module have a canonical
additive value map from each stalk to the function field.  Its image lies in
the point lattice, so it induces an additive map to the intrinsic jump
quotient.  This construction uses no uniformizer or residue-field coordinate.
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

/-! ## The stalk value map -/

def valAddHom (D : CurveDivisor k X) (U : X.left.Opens) :
    (divisorModule D).val.presheaf.obj (op U) →+ X.left.functionField :=
  AddMonoidHom.mk' (fun s => ((show divisorSections D U from s) : X.left.functionField)) (by
    intro a b
    rfl)

def valCocone (D : CurveDivisor k X) (x : X.left) :
    Cocone ((OpenNhds.inclusion x).op ⋙ (divisorModule D).val.presheaf) where
  pt := AddCommGrpCat.of X.left.functionField
  ι :=
    { app := fun U => AddCommGrpCat.ofHom (valAddHom D U.unop.1)
      naturality := fun U V i => by
        ext s
        exact divisorSectionsRes_coe (leOfHom i.unop) ⟨x, V.unop.2⟩ s }

/-- The canonical additive value of a divisor-module stalk element in the
function field. -/
def stalkVal (D : CurveDivisor k X) (x : X.left) :
    Scheme.Modules.Stalk (divisorModule D) x →+ X.left.functionField :=
  let f : ((TopCat.Presheaf.stalk (divisorModule D).val.presheaf x : Ab) : Type u) →+
      X.left.functionField :=
    AddMonoidHom.mk' (ConcreteCategory.hom
      (colimit.desc _ (valCocone D x))) (by
        intro a b
        exact map_add _ a b)
  f

lemma stalkVal_germ (D : CurveDivisor k X) (x : X.left) (U : X.left.Opens)
    (hxU : x ∈ U) (s : (divisorModule D).val.presheaf.obj (op U)) :
    stalkVal D x (ConcreteCategory.hom
      (TopCat.Presheaf.germ (divisorModule D).val.presheaf U x hxU) s) =
      ((show divisorSections D U from s) : X.left.functionField) := by
  dsimp [stalkVal, valCocone]
  change ConcreteCategory.hom (colimit.desc _ (valCocone D x))
      ((ConcreteCategory.hom
        (TopCat.Presheaf.germ (divisorModule D).val.presheaf U x hxU)) s) = _
  let j : (OpenNhds x)ᵒᵖ := op ⟨U, hxU⟩
  have hcat := colimit.ι_desc (valCocone D x) j
  have hfun := CategoryTheory.congr_fun hcat s
  have hcomp := ConcreteCategory.comp_apply
    (colimit.ι ((OpenNhds.inclusion x).op ⋙ (divisorModule D).val.presheaf) j)
    (colimit.desc _ (valCocone D x)) s
  have hfirst :
      ConcreteCategory.hom (colimit.desc _ (valCocone D x))
          (ConcreteCategory.hom (colimit.ι ((OpenNhds.inclusion x).op ⋙
            (divisorModule D).val.presheaf) j) s) =
        ConcreteCategory.hom ((valCocone D x).ι.app j) s := by
    rw [← hcomp, hfun]
    rfl
  exact hfirst.trans (by rfl)

/-- The stalk value map is injective because bounded rational sections are
subobjects of the function field and a germ equality is witnessed on a common
neighborhood. -/
lemma stalkVal_injective (D : CurveDivisor k X) (x : X.left) :
    Function.Injective (stalkVal D x) := by
  intro a b hab
  obtain ⟨U, hxU, s, rfl⟩ :=
    TopCat.Presheaf.exists_germ_eq (divisorModule D).val.presheaf a
  obtain ⟨V, hxV, t, rfl⟩ :=
    TopCat.Presheaf.exists_germ_eq (divisorModule D).val.presheaf b
  have hval : (show divisorSections D U from s : X.left.functionField) =
      (show divisorSections D V from t : X.left.functionField) := by
    rw [stalkVal_germ, stalkVal_germ] at hab
    exact hab
  let W : X.left.Opens := U ⊓ V
  have hxW : x ∈ W := ⟨hxU, hxV⟩
  have hsec :
      (divisorModule D).val.presheaf.map (homOfLE (inf_le_left : W ≤ U)).op s =
        (divisorModule D).val.presheaf.map (homOfLE (inf_le_right : W ≤ V)).op t := by
    apply Subtype.ext
    rw [show ((divisorModule D).val.presheaf.map
        (homOfLE (inf_le_left : W ≤ U)).op s : divisorSections D W) =
        divisorSectionsRes D (inf_le_left : W ≤ U) s from rfl,
      show ((divisorModule D).val.presheaf.map
        (homOfLE (inf_le_right : W ≤ V)).op t : divisorSections D W) =
        divisorSectionsRes D (inf_le_right : W ≤ V) t from rfl,
      divisorSectionsRes_coe (inf_le_left : W ≤ U) ⟨x, hxW⟩ s,
      divisorSectionsRes_coe (inf_le_right : W ≤ V) ⟨x, hxW⟩ t,
      hval]
  rw [← TopCat.Presheaf.germ_res_apply
    (divisorModule D).val.presheaf (homOfLE (inf_le_left : W ≤ U)) x hxW s,
    ← TopCat.Presheaf.germ_res_apply
    (divisorModule D).val.presheaf (homOfLE (inf_le_right : W ≤ V)) x hxW t,
    hsec]

/-! ## The point-lattice and jump maps -/

lemma stalkVal_mem_pointLattice {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) (m : Scheme.Modules.Stalk (divisorModule D) x) :
    stalkVal D x m ∈ pointLattice (X := X) hx (CurveDivisor.coeffAt hx D) := by
  obtain ⟨U, hxU, s, rfl⟩ :=
    TopCat.Presheaf.exists_germ_eq (divisorModule D).val.presheaf m
  rw [stalkVal_germ]
  let sU : divisorSections D U := s
  exact divisorSections_le_pointLattice hx D U hxU sU.property

/-- The stalk value map, with its image regarded as the point lattice. -/
def stalkValPointLattice {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) :
    Scheme.Modules.Stalk (divisorModule D) x →+
      pointLattice (X := X) hx (CurveDivisor.coeffAt hx D) :=
  (stalkVal D x).codRestrict _ (fun m => stalkVal_mem_pointLattice hx D m)

/-- The additive map from the divisor-module stalk to the intrinsic local jump
quotient.  No residue-field or uniformizer structure is asserted here. -/
def stalkJump {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) :
    Scheme.Modules.Stalk (divisorModule D) x →+ (jumpModule hx D) :=
  ((Submodule.mkQ
      ((pointLattice (X := X) hx (CurveDivisor.coeffAt hx D - 1)).submoduleOf
        (pointLattice (X := X) hx (CurveDivisor.coeffAt hx D)))).toAddMonoidHom).comp
    (stalkValPointLattice hx D)

lemma stalkJump_germ {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) (U : X.left.Opens) (hxU : x ∈ U)
    (s : (divisorModule D).val.presheaf.obj (op U)) :
    stalkJump hx D
        (ConcreteCategory.hom
          (TopCat.Presheaf.germ (divisorModule D).val.presheaf U x hxU) s) =
      jumpProj hx D U hxU (show divisorSections D U from s) := by
  let P : Submodule k (pointLattice (X := X) hx (CurveDivisor.coeffAt hx D)) :=
    (pointLattice (X := X) hx (CurveDivisor.coeffAt hx D - 1)).submoduleOf
      (pointLattice (X := X) hx (CurveDivisor.coeffAt hx D))
  change (Submodule.Quotient.mk (p := P)
      (⟨stalkVal D x
          (ConcreteCategory.hom
            (TopCat.Presheaf.germ (divisorModule D).val.presheaf U x hxU) s),
        stalkVal_mem_pointLattice hx D _⟩ :
        pointLattice (X := X) hx (CurveDivisor.coeffAt hx D)) :
      pointLattice (X := X) hx (CurveDivisor.coeffAt hx D) ⧸ P) =
    (Submodule.Quotient.mk (p := P)
      (⟨(show divisorSections D U from s : X.left.functionField),
        divisorSections_le_pointLattice hx D U hxU
          (show divisorSections D U from s).property⟩ :
        pointLattice (X := X) hx (CurveDivisor.coeffAt hx D)) :
      pointLattice (X := X) hx (CurveDivisor.coeffAt hx D) ⧸ P)
  apply congrArg Submodule.Quotient.mk
  apply Subtype.ext
  exact stalkVal_germ D x U hxU s

/-- The kernel criterion for the stalk-to-jump map, expressed intrinsically in
the lower point lattice. -/
lemma stalkJump_eq_zero_iff_mem_lower_lattice {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (m : Scheme.Modules.Stalk (divisorModule D) x) :
    stalkJump hx D m = 0 ↔
      stalkVal D x m ∈
        pointLattice (X := X) hx (CurveDivisor.coeffAt hx D - 1) := by
  obtain ⟨U, hxU, s, rfl⟩ :=
    TopCat.Presheaf.exists_germ_eq (divisorModule D).val.presheaf m
  rw [stalkJump_germ, stalkVal_germ]
  exact jumpProj_eq_zero_iff hx D hxU (show divisorSections D U from s)

end
end Hartshorne
