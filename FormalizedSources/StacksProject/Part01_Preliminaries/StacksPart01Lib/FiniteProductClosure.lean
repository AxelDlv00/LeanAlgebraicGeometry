/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.FiniteProduct

/-!
# Integral closures in finite dependent products

For a finite family of component maps with varying source rings, membership
in the integral closure of the product map is equivalent to componentwise
membership in the corresponding integral closures.
-/

namespace StacksPart01

/-! [Stacks tag 0CY9] -/

/-- Membership in the integral closure of a finite dependent product map is
componentwise membership in the integral closures of the component maps. -/
theorem mem_integralClosure_piMap_iff
    {ι : Type*} {R S : ι → Type*} [Finite ι]
    [∀ i, CommRing (R i)] [∀ i, CommRing (S i)]
    (f : ∀ i, R i →+* S i) (x : ∀ i, S i) :
    x ∈ @integralClosure (∀ i, R i) (∀ i, S i) _ _ (RingHom.piMap f).toAlgebra ↔
      ∀ i, x i ∈ @integralClosure (R i) (S i) _ _ (f i).toAlgebra := by
  rw [@mem_integralClosure_iff (∀ i, R i) (∀ i, S i) _ _
      (RingHom.piMap f).toAlgebra]
  simp only [@mem_integralClosure_iff]
  exact isIntegralElem_piMap_iff f x

end StacksPart01
