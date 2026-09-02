/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioRegularization
import HartshorneLib.Chapter4ProjectiveMapProducer

/-!
# Hartshorne IV.3.1: projective maps on denominator charts

An honest regularization of divisor-section ratios on a nonempty open gives
structure-sheaf sections on the corresponding open subscheme.  The selected
denominator is normalized to `1`, so the irrelevant ideal condition required by
`Proj.fromOfGlobalSections` follows internally.  This module constructs the
resulting projective morphism and records that its image lies in the standard
denominator chart.  Compatibility between different denominator charts remains
the separate gluing step.
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

attribute [local instance] MvPolynomial.gradedAlgebra

namespace LocalRatioRegularization

variable {a : LocalRatioCoordinateData D n}

/-! ### The chart as an object over the coefficient field -/

/-- The open subscheme underlying a local-ratio chart, over `Spec k`. -/
noncomputable def chartOver (a : LocalRatioCoordinateData D n) :
    Over (Spec (CommRingCat.of k)) :=
  Over.mk (a.chart.U.ι ≫ X.hom)

/-! ### Normalized sections and the irrelevant ideal -/

noncomputable local instance chartAlgebra : Algebra k Γ(a.chart.U, ⊤) :=
  (a.chart.U.toScheme.overAlgebraMap k (⊤ : a.chart.U.toScheme.Opens)).toAlgebra

/-- Transport a regularized section on `a.chart.U` to global sections of the
open subscheme. -/
noncomputable def chartSection (r : LocalRatioRegularization a)
    (i : Fin (n + 1)) : Γ(a.chart.U, ⊤) :=
  a.chart.U.topIso.inv.hom (r.regularized i)

@[simp] theorem chartSection_denominator_eq_one
    (r : LocalRatioRegularization a) :
    r.chartSection a.denominator_index = 1 := by
  simp [chartSection, r.regularized_denominator_eq_one]

/-- Evaluation of homogeneous coordinates at the normalized chart sections. -/
noncomputable def chartEval (r : LocalRatioRegularization a) :
    MvPolynomial (Fin (n + 1)) k →+* Γ(a.chart.U, ⊤) :=
  (MvPolynomial.aeval r.chartSection).toRingHom

@[simp] theorem chartEval_X (r : LocalRatioRegularization a)
    (i : Fin (n + 1)) :
    r.chartEval (MvPolynomial.X i) = r.chartSection i := by
  simp [chartEval]

/-- The normalized denominator makes the irrelevant ideal generate the whole
ring of sections, with no additional base-point-free assumption. -/
theorem chartEval_irrelevant_span (r : LocalRatioRegularization a) :
    (HomogeneousIdeal.irrelevant
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)).toIdeal.map
        r.chartEval = ⊤ := by
  rw [Ideal.eq_top_iff_one]
  have hX : MvPolynomial.X a.denominator_index ∈
      HomogeneousIdeal.irrelevant
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) :=
    HomogeneousIdeal.mem_irrelevant_of_mem _ one_pos
      ((MvPolynomial.mem_homogeneousSubmodule _ _).mpr
        (MvPolynomial.isHomogeneous_X k a.denominator_index))
  simpa [chartEval_X, chartSection_denominator_eq_one] using
    Ideal.mem_map_of_mem r.chartEval hX

/-! ### The local projective morphism -/

/-- The `Proj.fromOfGlobalSections` input supplied by a regularized chart. -/
noncomputable def projectiveMapData (r : LocalRatioRegularization a) :
    GlobalSectionsProjectiveMapData (k := k) (X := chartOver a) n :=
  { sections := r.chartSection
    irrelevant_span := r.chartEval_irrelevant_span }

/-- The projective morphism defined by the regularized local coordinates. -/
noncomputable def chartMap (r : LocalRatioRegularization a) :
    a.chart.U.toScheme ⟶ projectiveSpace k n :=
  r.projectiveMapData.map

@[reassoc (attr := simp)] theorem chartMap_over
    (r : LocalRatioRegularization a) :
    r.chartMap ≫ projectiveSpaceStructureMap k n = a.chart.U.ι ≫ X.hom := by
  exact r.projectiveMapData.map_over

/- The corresponding preimage-of-basic-open statement is deliberately left
  for the restriction/gluing phase: unfolding the generic `Proj` preimage
  theorem here makes elaboration depend on the full glued-map implementation. -/

end LocalRatioRegularization

end
end Hartshorne
