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

/-- Restricting the canonical chart map to its denominator standard open is
the affine map supplied by `toBasicOpenOfGlobalSections`. -/
theorem chartMap_morphismRestrict_denominator
    (r : LocalRatioRegularization a) :
    r.chartMap ∣_
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X a.denominator_index) =
      (Scheme.isoOfEq (r.chartMap_preimage_basicOpen
        a.denominator_index)).hom ≫
        Proj.toBasicOpenOfGlobalSections
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.aeval r.chartSection).toRingHom rfl
          Nat.zero_lt_one
          ((MvPolynomial.mem_homogeneousSubmodule _ _).mpr
            (MvPolynomial.isHomogeneous_X k a.denominator_index)) := by
  change
    (Proj.fromOfGlobalSections
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.aeval r.chartSection).toRingHom r.chartEval_irrelevant_span) ∣_
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X a.denominator_index) = _
  exact Proj.fromOfGlobalSections_morphismRestrict
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
    (MvPolynomial.aeval r.chartSection).toRingHom r.chartEval_irrelevant_span
    Nat.zero_lt_one
    ((MvPolynomial.mem_homogeneousSubmodule _ _).mpr
      (MvPolynomial.isHomogeneous_X k a.denominator_index))

end LocalRatioRegularization

namespace GlobalSectionsProjectiveMapData

attribute [local instance] MvPolynomial.gradedAlgebra

noncomputable local instance globalSectionsAlgebra : Algebra k Γ(X.left, ⊤) :=
  (X.left.overAlgebraMap k (⊤ : X.left.Opens)).toAlgebra

/-- The canonical projective map sends the inverse image of a standard
projective open to the principal open defined by the corresponding section. -/
@[simp] theorem map_preimage_basicOpen
    {n : ℕ} (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n)
    (j : Fin (n + 1)) :
    data.map ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j) =
      X.left.basicOpen (data.sections j) := by
  change
    Proj.fromOfGlobalSections
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.aeval data.sections).toRingHom data.irrelevant_span ⁻¹ᵁ
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X j) = _
  exact Proj.fromOfGlobalSections_preimage_basicOpen
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
    (MvPolynomial.aeval data.sections).toRingHom data.irrelevant_span
    Nat.zero_lt_one
    ((MvPolynomial.mem_homogeneousSubmodule _ _).mpr
      (MvPolynomial.isHomogeneous_X k j))

end GlobalSectionsProjectiveMapData

end
end Hartshorne
