/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioProjectiveChart

/-!
# Hartshorne IV.3.1: the canonical chart restriction

The local chart map is defined by `Proj.fromOfGlobalSections`.  This module
exposes its restriction to the standard open selected by the normalized
denominator, so later comparison with the explicit `ProjectiveCoordinates`
construction can be made on an affine target chart.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry
open MvPolynomial

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}
variable {n : ℕ}

namespace LocalRatioRegularization

variable {a : LocalRatioCoordinateData D n}

attribute [local instance] MvPolynomial.gradedAlgebra

noncomputable local instance chartAlgebraBridge : Algebra k Γ(a.chart.U, ⊤) :=
  (a.chart.U.toScheme.overAlgebraMap k (⊤ : a.chart.U.toScheme.Opens)).toAlgebra

theorem chartMap_preimage_basicOpen_eval
    (r : LocalRatioRegularization a) (j : Fin (n + 1)) :
    r.chartMap ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j) =
      a.chart.U.toScheme.basicOpen
        (((MvPolynomial.aeval r.chartSection).toRingHom :
          MvPolynomial (Fin (n + 1)) k →+* Γ(a.chart.U, ⊤))
          (MvPolynomial.X j)) := by
  rw [r.chartMap_preimage_basicOpen]
  exact congrArg (fun z => a.chart.U.toScheme.basicOpen z) (r.chartEval_X j).symm

set_option maxHeartbeats 800000 in
-- The canonical Proj restriction expands through a large glued cover.
/-- Restricting the canonical chart map to its denominator standard open is
the affine map supplied by `toBasicOpenOfGlobalSections`. -/
theorem chartMap_morphismRestrict_denominator
    (r : LocalRatioRegularization a) :
    r.chartMap ∣_
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X a.denominator_index) =
      (Scheme.isoOfEq a.chart.U.toScheme (chartMap_preimage_basicOpen_eval
        (a := a) r
        a.denominator_index)).hom ≫
        Proj.toBasicOpenOfGlobalSections
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.aeval r.chartSection).toRingHom rfl
          Nat.zero_lt_one
          ((MvPolynomial.mem_homogeneousSubmodule _ _).mpr
            (MvPolynomial.isHomogeneous_X k a.denominator_index)) := by
  let f : MvPolynomial (Fin (n + 1)) k →+* Γ(a.chart.U, ⊤) :=
    (MvPolynomial.aeval r.chartSection).toRingHom
  have hf :
      (HomogeneousIdeal.irrelevant
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)).toIdeal.map f = ⊤ := by
    exact chartEval_irrelevant_span (a := a) r
  have hdeg : MvPolynomial.X a.denominator_index ∈
      MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k 1 :=
    (MvPolynomial.mem_homogeneousSubmodule _ _).mpr
      (MvPolynomial.isHomogeneous_X k a.denominator_index)
  change
    (Proj.fromOfGlobalSections
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) f hf) ∣_
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X a.denominator_index) = _
  have hrestrict :=
    Proj.fromOfGlobalSections_morphismRestrict
      (𝒜 := MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (f := f) (hf := hf) (r := MvPolynomial.X a.denominator_index) (n := 1)
      Nat.zero_lt_one hdeg
  convert hrestrict using 1
  all_goals simp only [f]
  all_goals rfl

end LocalRatioRegularization

namespace GlobalSectionsProjectiveMapData

attribute [local instance] MvPolynomial.gradedAlgebra

noncomputable local instance globalSectionsAlgebra : Algebra k Γ(X.left, ⊤) :=
  (X.left.overAlgebraMap k (⊤ : X.left.Opens)).toAlgebra

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- The canonical projective map sends the inverse image of a standard
projective open to the principal open defined by the corresponding section. -/
@[simp] theorem map_preimage_basicOpen
    {n : ℕ} (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n)
    (j : Fin (n + 1)) :
    data.map ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j) =
      X.left.basicOpen (data.sections j) := by
  let f : MvPolynomial (Fin (n + 1)) k →+* Γ(X.left, ⊤) :=
    (MvPolynomial.aeval data.sections).toRingHom
  have hf :
      (HomogeneousIdeal.irrelevant
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)).toIdeal.map f = ⊤ := by
    exact data.irrelevant_span
  have hdeg : MvPolynomial.X j ∈
      MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k 1 :=
    (MvPolynomial.mem_homogeneousSubmodule _ _).mpr
      (MvPolynomial.isHomogeneous_X k j)
  change
    Proj.fromOfGlobalSections
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) f hf ⁻¹ᵁ
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X j) = _
  have hpre :=
    Proj.fromOfGlobalSections_preimage_basicOpen
      (𝒜 := MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (f := f) (hf := hf) (r := MvPolynomial.X j) (n := 1)
      Nat.zero_lt_one hdeg
  simpa [f] using hpre

end GlobalSectionsProjectiveMapData

end
end Hartshorne
