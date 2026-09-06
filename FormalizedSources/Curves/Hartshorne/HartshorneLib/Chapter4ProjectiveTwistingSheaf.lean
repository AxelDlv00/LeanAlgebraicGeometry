/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter2LineBundleGluing
import HartshorneLib.Chapter4ProjectiveTwistTransition

/-!
# The projective twisting sheaf O(1)

Sections are families of regular functions on the standard projective charts.
For the frame `X_i`, the representatives satisfy `s_i = (X_j / X_i) * s_j`.
The homogeneous coordinate `X_j` is the family `X_j / X_i`.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry MvPolynomial

namespace Hartshorne.ProjectiveTwist

noncomputable section

variable {k : Type (max u v)} [Field k] {J : Type v}

attribute [local instance] MvPolynomial.gradedAlgebra

/-- The multiplier for matching representatives in the frames `X_i` and
`X_j`. This is the inverse of the change from the `i`-frame to the `j`-frame. -/
def matchingUnit (i j : J) :
    Γ(Proj (homogeneousSubmodule J k), chart i ⊓ chart j)ˣ :=
  (transition i j)⁻¹

@[simp] lemma matchingUnit_val (i j : J) :
    (matchingUnit (k := k) i j).val =
      (Proj (homogeneousSubmodule J k)).resHom inf_le_left (coordinate i j) := rfl

/-- The projective coordinate multipliers satisfy the sheaf gluing cocycle. -/
theorem matchingCocycle :
    LineBundleGluing.IsCocycle (chart (k := k) (J := J)) matchingUnit where
  unit_self i := by simp [matchingUnit_val]
  mul_res i j l := by
    simp only [matchingUnit_val, Scheme.resHom_resHom]
    exact coordinate_mul i j l
      (inf_le_left.trans inf_le_left) (inf_le_left.trans inf_le_right)

/-- The actual structure-sheaf module `O(1)` on the projective spectrum. -/
def twistingSheafOne : (Proj (homogeneousSubmodule J k)).Modules :=
  LineBundleGluing.gluedModule (chart (k := k) (J := J)) matchingUnit

/-- The standard frame `X_i` trivializes `O(1)` on its projective chart. -/
def trivialization (i : J) :=
  LineBundleGluing.trivialization (matchingCocycle (k := k)) i

/-- The projective twisting sheaf is a line bundle. -/
theorem isLineBundle_twistingSheafOne :
    IsLineBundle (twistingSheafOne (k := k) (J := J)) :=
  LineBundleGluing.isLineBundle (matchingCocycle (k := k)) iSup_chart

/-- The homogeneous coordinate `X_j`, restricted to an arbitrary open, is
represented in the `i`-frame by `X_j / X_i`. -/
def coordinateSection (j : J) (W : (Proj (homogeneousSubmodule J k)).Opens) :
    Γ(twistingSheafOne (k := k) (J := J), W) :=
  LineBundleGluing.mkSectionOfLocal.{u, v} (chart.{u, v} (k := k) (J := J))
    matchingUnit.{u, v} W (fun i => coordinate.{u, v} i j) (by
      intro i l
      exact (coordinate_mul.{u, v} i l j inf_le_left inf_le_right).symm)

/-- Coordinate sections commute with restriction on the projective scheme. -/
theorem coordinateSection_restrict {W V : (Proj (homogeneousSubmodule J k)).Opens}
    (h : V ≤ W) (j : J) :
    (twistingSheafOne.{u, v} (k := k) (J := J)).presheaf.map (homOfLE h).op
        (coordinateSection.{u, v} j W) = coordinateSection.{u, v} j V := by
  exact LineBundleGluing.map_mkSectionOfLocal.{u, v} _ _ _ _ _ h

/-- In the `i`-frame, the coordinate section `X_j` has the expected value. -/
theorem sectionTriv_coordinateSection (i j : J)
    {W : (Proj (homogeneousSubmodule J k)).Opens} (hW : W ≤ chart.{u, v} i) :
    (LineBundleGluing.sectionTriv.{u, v} (matchingCocycle.{u, v} (k := k)) i hW).toFun
        (coordinateSection.{u, v} j W) =
      (Proj (homogeneousSubmodule J k)).resHom hW (coordinate.{u, v} i j) := by
  exact LineBundleGluing.sectionTriv_mkSectionOfLocal.{u, v} _ i hW _ _

/-- The homogeneous coordinate `X_i` is a local generator in its own frame. -/
theorem sectionTriv_coordinateSection_self (i : J)
    {W : (Proj (homogeneousSubmodule J k)).Opens} (hW : W ≤ chart.{u, v} i) :
    (LineBundleGluing.sectionTriv.{u, v} (matchingCocycle.{u, v} (k := k)) i hW).toFun
        (coordinateSection.{u, v} i W) = 1 := by
  rw [sectionTriv_coordinateSection.{u, v}, coordinate_self.{u, v}, map_one]

end
end Hartshorne.ProjectiveTwist
