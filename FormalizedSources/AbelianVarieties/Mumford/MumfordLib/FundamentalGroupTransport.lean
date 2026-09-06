/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup

/-!
# Fundamental groups under based homeomorphisms

Transport along the uniformization homeomorphism preserves the basepoint and
the fundamental-group multiplication. This uses Mathlib's induced map on
fundamental groups, with its explicit action on loop representatives.
-/

set_option autoImplicit false

noncomputable section

namespace Mumford.Uniformization

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

/-- Inverse continuous maps give inverse maps on based loop classes. -/
theorem fundamentalGroup_mapOfEq_leftInverse
    (f : C(X, Y)) (g : C(Y, X)) (hgf : Function.LeftInverse g f)
    {x : X} {y : Y} (hf : f x = y) (hg : g y = x)
    (p : FundamentalGroup X x) :
    FundamentalGroup.mapOfEq g hg (FundamentalGroup.mapOfEq f hf p) = p := by
  induction p using Path.Homotopic.Quotient.ind with
  | mk p =>
    rw [FundamentalGroup.mapOfEq_apply, FundamentalGroup.mapOfEq_apply]
    apply congrArg (fun q : Path x x => FundamentalGroup.fromPath (.mk q))
    ext t
    exact hgf (p t)

/-- A homeomorphism carrying `x` to `y` induces an isomorphism of fundamental groups. -/
def fundamentalGroupHomeomorphEquiv (e : X ≃ₜ Y)
    {x : X} {y : Y} (h : e x = y) :
    FundamentalGroup X x ≃* FundamentalGroup Y y :=
  { FundamentalGroup.mapOfEq ⟨e, e.continuous⟩ h with
    invFun := FundamentalGroup.mapOfEq ⟨e.symm, e.symm.continuous⟩
      (e.symm_apply_eq.mpr h.symm)
    left_inv := fundamentalGroup_mapOfEq_leftInverse
      ⟨e, e.continuous⟩ ⟨e.symm, e.symm.continuous⟩ e.left_inv h _
    right_inv := fundamentalGroup_mapOfEq_leftInverse
      ⟨e.symm, e.symm.continuous⟩ ⟨e, e.continuous⟩ e.right_inv _ h }

end Mumford.Uniformization
