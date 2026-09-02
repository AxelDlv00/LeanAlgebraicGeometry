/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.Normal

/-!
# Normal localizations

The source's localization statement is expressed with the necessary
nonzero-denominator condition made explicit.
-/

namespace StacksPart01

open scoped nonZeroDivisors

/-! [Stacks tag 00GY] -/

/-- A localization of a normal domain away from zero is again a normal domain. -/
theorem localization_isNormalDomain
    {R T : Type*} [CommRing R] [CommRing T] [Algebra R T]
    [IsDomain R] [IsIntegrallyClosed R] (M : Submonoid R)
    (hM : M ≤ nonZeroDivisors R) [IsLocalization M T] :
    IsDomain T ∧ IsIntegrallyClosed T := by
  exact ⟨IsLocalization.isDomain_of_le_nonZeroDivisors T hM,
    isIntegrallyClosed_of_isLocalization T M hM⟩

end StacksPart01
