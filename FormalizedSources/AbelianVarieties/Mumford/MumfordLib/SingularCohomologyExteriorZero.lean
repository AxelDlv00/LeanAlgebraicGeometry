/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyExterior
import MumfordLib.SingularCohomologyZeroConnected

/-!
# The degree-zero exterior cup comparison

For a path-connected space, the empty cup is the positive generator of
integral degree-zero cohomology. Thus the degree-zero exterior comparison is
the composite of the canonical zeroth exterior-power equivalence with the
inverse of zero-cocycle evaluation. This is the degree-zero base case of the
torus calculation in Mumford, Chapter I, Section 1, p. 3.
-/

set_option autoImplicit false

noncomputable section

namespace Mumford.Analytic

/-- The degree-zero exterior comparison sends the scalar generator to the
constant-one cohomology class. -/
theorem singularCohomologyExteriorPower_zero (X : TopCat) [PathConnectedSpace X] (x : X) :
    singularCohomologyExteriorPower X 0 =
      ((exteriorPower.zeroEquiv ℤ (IntegralSingularCohomology X 1)).trans
        (singularZeroCohomologyEquivInt X x).symm).toLinearMap := by
  apply exteriorPower.linearMap_ext
  ext v
  change singularCohomologyExteriorPower X 0 (exteriorPower.ιMulti ℤ 0 v) =
    (singularZeroCohomologyEquivInt X x).symm
      (exteriorPower.zeroEquiv ℤ (IntegralSingularCohomology X 1)
        (exteriorPower.ιMulti ℤ 0 v))
  rw [singularCohomologyExteriorPower_ιMulti, exteriorPower.zeroEquiv_ιMulti]
  change singularCohomologyOne X = (singularZeroCohomologyEquivInt X x).symm 1
  apply (singularZeroCohomologyEquivInt X x).injective
  rw [LinearEquiv.apply_symm_apply, singularZeroCohomologyEquivInt_one]

/-- The exterior cup comparison is bijective in degree zero for a
path-connected space. -/
theorem singularCohomologyExteriorPower_zero_bijective (X : TopCat) [PathConnectedSpace X] :
    Function.Bijective (singularCohomologyExteriorPower X 0) := by
  obtain ⟨x⟩ := (inferInstance : Nonempty X)
  rw [singularCohomologyExteriorPower_zero X x]
  exact ((exteriorPower.zeroEquiv ℤ (IntegralSingularCohomology X 1)).trans
    (singularZeroCohomologyEquivInt X x).symm).bijective

end Mumford.Analytic
