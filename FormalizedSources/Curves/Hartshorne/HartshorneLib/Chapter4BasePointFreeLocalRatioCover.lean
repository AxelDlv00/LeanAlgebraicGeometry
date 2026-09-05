/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasisJumpWitness
import HartshorneLib.Chapter4BasePointFreeDenominatorOpen
import HartshorneLib.Chapter4LocalRatioProjectiveGluing

/-!
# The indexed regularized local-ratio cover

For a fixed finite basis of the global divisor-section space, the local jump
producer selects a basis coordinate at each non-generic point.  The exact-order
open producer then supplies a regularized local-ratio chart.  This file packages
those choices into an indexed cover and feeds it to the existing projective
gluing API.  The explicit `Nonempty` hypothesis is retained because it is the
only input used to cover the generic point; no closed-point existence theorem
is hidden in this construction.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}

/-- The points at which the local jump producer is applicable. -/
abbrev NonGenericPoint (X : Over (Spec (CommRingCat.of k)))
    [IsIntegral X.left] : Type u :=
  {x : X.left // x ≠ genericPoint X.left}

namespace BasePointFreeLocalRatioCover

variable {n : ℕ}

/-! ### Global basis sections and selected local data -/

/-- The global divisor sections represented by a fixed basis. -/
noncomputable def basisSections
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D)) :
    Fin (n + 1) → divisorSections D (⊤ : X.left.Opens) :=
  fun i => divisorSectionSpaceEquiv (D := D) (basis i)

lemma basisSection_ne_zero_of_jump
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    {i : Fin (n + 1)} {x : X.left} (hx : x ≠ genericPoint X.left)
    (hi : jumpProj hx D ⊤ trivial
      (basisSections (D := D) basis i) ≠ 0) :
    (basisSections (D := D) basis i : X.left.functionField) ≠ 0 := by
  intro hzero
  apply hi
  have hsection : basisSections (D := D) basis i = 0 := Subtype.ext hzero
  rw [hsection, map_zero]

/-- The basis coordinate selected at a non-generic point. -/
noncomputable def selectedIndex
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X) : Fin (n + 1) :=
  Classical.choose
    (exists_basisSection_jumpProj_ne_zero_of_basePointFree
      (D := D) basis hD x.1 x.2)

lemma selectedIndex_spec
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X) :
    jumpProj x.2 D ⊤ trivial
      (basisSections (D := D) basis (selectedIndex (D := D) basis hD x)) ≠ 0 :=
  Classical.choose_spec
    (exists_basisSection_jumpProj_ne_zero_of_basePointFree
      (D := D) basis hD x.1 x.2)

lemma selectedSection_ne_zero
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X) :
    (basisSections (D := D) basis (selectedIndex (D := D) basis hD x) :
      X.left.functionField) ≠ 0 :=
  basisSection_ne_zero_of_jump basis x.2 (selectedIndex_spec basis hD x)

lemma selectedSection_orderAt
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X) :
    orderAt X.hom x.2
      (basisSections (D := D) basis (selectedIndex (D := D) basis hD x) :
        X.left.functionField) = divisorBound D x.2 := by
  exact orderAt_eq_divisorBound_of_jumpProj_ne_zero x.2 D
    (U := ⊤) (by simp)
    (basisSections (D := D) basis (selectedIndex (D := D) basis hD x))
    (selectedIndex_spec basis hD x)

/-- The exact-order open chosen around each non-generic point. -/
noncomputable def selectedOpen
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X) :
    LocalRatioOpen X :=
  Classical.choose
    (exists_localRatioOpen_orderAt_eq
      (D := D)
      (basisSections (D := D) basis (selectedIndex (D := D) basis hD x))
      (selectedSection_ne_zero basis hD x) (x := x.1) x.2
      (selectedSection_orderAt basis hD x))

lemma selectedOpen_spec
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X) :
    x.1 ∈ (selectedOpen (D := D) basis hD x).U ∧
      ∀ (z : X.left) (hz : z ≠ genericPoint X.left),
        z ∈ (selectedOpen (D := D) basis hD x).U →
          orderAt X.hom hz
            (basisSections (D := D) basis
              (selectedIndex (D := D) basis hD x) : X.left.functionField) =
            divisorBound D hz :=
  Classical.choose_spec
    (exists_localRatioOpen_orderAt_eq
      (D := D)
      (basisSections (D := D) basis (selectedIndex (D := D) basis hD x))
      (selectedSection_ne_zero basis hD x) (x := x.1) x.2
      (selectedSection_orderAt basis hD x))

/-- The local coordinate datum obtained by restricting the selected global
section family to the selected exact-order open. -/
noncomputable def selectedCoordinates
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X) :
    LocalRatioCoordinateData D n :=
  LocalRatioCoordinateData.ofGlobalSections
    (basisSections (D := D) basis)
    (selectedOpen (D := D) basis hD x)
    (selectedIndex (D := D) basis hD x)
    (selectedSection_ne_zero basis hD x)

lemma selectedCoordinates_section_value
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X)
    (i : Fin (n + 1)) :
    ((selectedCoordinates (D := D) basis hD x).sections i : X.left.functionField) =
      (basisSections (D := D) basis i : X.left.functionField) := by
  exact LocalRatioCoordinateData.ofGlobalSections_section_value
    (basisSections (D := D) basis)
    (selectedOpen (D := D) basis hD x)
    (selectedIndex (D := D) basis hD x)
    i (selectedSection_ne_zero basis hD x)

/-! ### Regularization and compatibility -/

/-- The selected coordinates are regularized using their exact-order bound. -/
noncomputable def selectedRegularization
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X) :
    LocalRatioRegularization (selectedCoordinates (D := D) basis hD x) :=
  LocalRatioRegularization.of_denominatorOrderEq
    (selectedCoordinates (D := D) basis hD x) (by
      intro z hz hzU
      rw [selectedCoordinates_section_value]
      exact (selectedOpen_spec basis hD x).2 z hz hzU)

lemma selectedCoordinates_sameSectionValues
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x y : NonGenericPoint X) :
    (selectedCoordinates (D := D) basis hD x).SameSectionValues
      (selectedCoordinates (D := D) basis hD y) := by
  exact LocalRatioCoordinateData.ofGlobalSections_sameSectionValues
    (basisSections (D := D) basis)
    (selectedOpen (D := D) basis hD x)
    (selectedOpen (D := D) basis hD y)
    (selectedIndex (D := D) basis hD x)
    (selectedIndex (D := D) basis hD y)
    (selectedSection_ne_zero basis hD x)
    (selectedSection_ne_zero basis hD y)

/-! ### The cover and the glued projective morphism -/

/-- The selected local-ratio opens cover the whole curve.  The generic point
is covered by any selected open; the non-generic points are covered by their
own selected opens. -/
theorem selectedCoordinates_isOpenCover
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    (hpoint : Nonempty (NonGenericPoint X)) :
    IsOpenCover (fun x : NonGenericPoint X =>
      (selectedCoordinates (D := D) basis hD x).chart.U) := by
  refine top_le_iff.mp (fun z hz => ?_)
  by_cases hzg : z = genericPoint X.left
  · obtain ⟨x⟩ := hpoint
    subst z
    exact TopologicalSpace.Opens.mem_iSup.mpr
      ⟨x, (selectedCoordinates (D := D) basis hD x).chart.generic_mem⟩
  · let x : NonGenericPoint X := ⟨z, hzg⟩
    exact TopologicalSpace.Opens.mem_iSup.mpr
      ⟨x, (selectedOpen_spec basis hD x).1⟩

/-- The projective morphism obtained by gluing the selected normalized local
ratio charts. -/
noncomputable def gluedMap
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    (hpoint : Nonempty (NonGenericPoint X)) :
    X.left ⟶ projectiveSpace k n :=
  LocalRatioProjectiveGluing.gluedFromOpen
    (a := fun x : NonGenericPoint X =>
      selectedCoordinates (D := D) basis hD x)
    (r := fun x : NonGenericPoint X =>
      selectedRegularization (D := D) basis hD x)
    (hcover := selectedCoordinates_isOpenCover basis hD hpoint)
    (selectedCoordinates_sameSectionValues (D := D) basis hD)

@[reassoc (attr := simp)] theorem gluedMap_over
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    (hpoint : Nonempty (NonGenericPoint X)) :
    gluedMap (D := D) basis hD hpoint ≫ projectiveSpaceStructureMap k n = X.hom := by
  exact LocalRatioProjectiveGluing.gluedFromOpen_over
    (a := fun x : NonGenericPoint X =>
      selectedCoordinates (D := D) basis hD x)
    (r := fun x : NonGenericPoint X =>
      selectedRegularization (D := D) basis hD x)
    (hcover := selectedCoordinates_isOpenCover basis hD hpoint)
    (selectedCoordinates_sameSectionValues (D := D) basis hD)

end BasePointFreeLocalRatioCover

end
end Hartshorne
