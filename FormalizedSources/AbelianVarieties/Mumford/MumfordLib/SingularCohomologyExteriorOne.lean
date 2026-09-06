/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyExterior

/-!
# The degree-one exterior comparison

The degree-one piece of the exterior-power comparison is the canonical
one-factor exterior-power equivalence.  This is the base case for the
circle/product Kunneth induction in the torus calculation.
-/

set_option autoImplicit false

noncomputable section

namespace Mumford.Analytic

variable {X : TopCat}

/-- The degree-one comparison evaluates a one-factor wedge to its factor. -/
@[simp]
theorem singularCohomologyExteriorPower_one_ιMulti (X : TopCat)
    (v : Fin 1 → IntegralSingularCohomology X 1) :
    singularCohomologyExteriorPower X 1 (exteriorPower.ιMulti ℤ 1 v) = v 0 := by
  rw [singularCohomologyExteriorPower_ιMulti]
  change singularCohomologyCup X 1 0 1 rfl (v 0) (singularCohomologyOne X) = v 0
  exact singularCohomologyCup_one_right (v 0)

/-- The degree-one cup comparison is the canonical one-factor exterior
equivalence. -/
theorem singularCohomologyExteriorPower_one (X : TopCat) :
    singularCohomologyExteriorPower X 1 =
      (exteriorPower.oneEquiv ℤ (IntegralSingularCohomology X 1)).toLinearMap := by
  apply exteriorPower.linearMap_ext
  ext v
  exact (singularCohomologyExteriorPower_one_ιMulti X v).trans
    (exteriorPower.oneEquiv_ιMulti v).symm

/-- The exterior cup comparison is bijective in degree one for every space. -/
theorem singularCohomologyExteriorPower_one_bijective (X : TopCat) :
    Function.Bijective (singularCohomologyExteriorPower X 1) := by
  rw [singularCohomologyExteriorPower_one]
  exact (exteriorPower.oneEquiv ℤ (IntegralSingularCohomology X 1)).bijective

end Mumford.Analytic
