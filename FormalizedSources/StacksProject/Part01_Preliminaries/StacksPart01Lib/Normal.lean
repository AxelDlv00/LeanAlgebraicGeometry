/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.GoingUp
import Mathlib.RingTheory.IntegralClosure.IntegrallyClosed

/-!
# Normality of integral closures

The integral closure of a ring in a normal domain is again a normal domain.
The proposition-valued pair below is the Lean form of the source's
``normal domain`` conclusion: a domain together with integrally closedness.
-/

namespace StacksPart01

open scoped nonZeroDivisors Polynomial

/-! [Stacks tag 034L] -/

/-- The integral closure in a normal domain is a normal domain. -/
theorem integralClosure_isNormalDomain
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [IsDomain S] [IsIntegrallyClosed S] :
    IsDomain (integralClosure R S) ∧ IsIntegrallyClosed (integralClosure R S) := by
  constructor
  · infer_instance
  · exact IsIntegrallyClosed.of_isIntegrallyClosed_of_isIntegrallyClosedIn
      (integralClosure R S) S

end StacksPart01
