/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DegreeClass
import HartshorneLib.Chapter4WeightedDegree

/-!
# Product-formula bridge for curve divisors

The global product formula is naturally stated with residue-field weights over
an arbitrary field.  On the algebraically closed curves formalized here, those
weights are all one.  This file packages that reduction at the exact interface
consumed by the divisor-class construction.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open AlgebraicGeometry

namespace Hartshorne

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

/-- A residue-weighted product formula on an algebraically closed curve gives
the degree-zero assertion used to descend divisor degree to divisor classes. -/
theorem principalDivisorsHaveDegreeZero_of_residueWeightedProductFormula
    (hformula : ∀ g : X.left.functionFieldˣ,
      CurveDivisor.residueWeightedDegree (principalDivisor g) = 0) :
    PrincipalDivisorsHaveDegreeZero (k := k) (X := X) := by
  intro g
  rw [← CurveDivisor.residueWeightedDegree_eq_degree]
  exact hformula g

end Hartshorne
