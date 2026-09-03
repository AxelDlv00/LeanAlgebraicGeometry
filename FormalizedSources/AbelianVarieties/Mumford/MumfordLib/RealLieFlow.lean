/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexLieOneParameter

/-!
# Canonical real one-parameter flows

This file packages the existence theorem for central real one-parameter
subgroups into a choice-valued flow.  The choice is canonical for the API,
while the uniqueness theorem below makes all statements independent of that
choice.
-/

set_option autoImplicit false

noncomputable section

open Function Set
open scoped Manifold ContDiff

namespace Mumford
namespace Analytic

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I ω G]

/-- The chosen real one-parameter subgroup associated to a realified tangent
vector. -/
def canonicalRealFlow
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v : GroupLieAlgebra (complexToRealModel I) G) : ℝ → G :=
  Classical.choose (exists_central_real_oneParameterSubgroup_of_complexLieGroup I v)

/-- The chosen flow satisfies the existence, subgroup, and centrality
specification. -/
theorem canonicalRealFlow_spec
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v : GroupLieAlgebra (complexToRealModel I) G) :
    canonicalRealFlow I v 0 = 1 ∧
      IsMIntegralCurve (canonicalRealFlow I v)
        (mulInvariantVectorField (I := complexToRealModel I) v) ∧
      (∀ s t : ℝ, canonicalRealFlow I v (s + t) =
        canonicalRealFlow I v s * canonicalRealFlow I v t) ∧
      ∀ x : G, ∀ t : ℝ, Commute x (canonicalRealFlow I v t) := by
  exact Classical.choose_spec
    (exists_central_real_oneParameterSubgroup_of_complexLieGroup I v)

/-- Any global integral curve through the identity is the canonical flow. -/
theorem canonicalRealFlow_eq_of_isMIntegralCurve
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    {v : GroupLieAlgebra (complexToRealModel I) G} {γ : ℝ → G}
    (hγ : IsMIntegralCurve γ
      (mulInvariantVectorField (I := complexToRealModel I) v))
    (hγ0 : γ 0 = 1) :
    γ = canonicalRealFlow I v := by
  apply isMIntegralCurve_eq_of_eq_at (I := complexToRealModel I)
    hγ (canonicalRealFlow_spec I v).2.1 0
  exact hγ0.trans (canonicalRealFlow_spec I v).1.symm

/-- The zero tangent vector has the constant identity flow. -/
theorem canonicalRealFlow_zero
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] :
    canonicalRealFlow I (0 : GroupLieAlgebra (complexToRealModel I) G) =
      fun _ => (1 : G) := by
  have hzero := canonicalRealFlow_spec I
    (0 : GroupLieAlgebra (complexToRealModel I) G)
  have hscaled := oneParameterSubgroup_smul_eq
    (I := complexToRealModel I)
    (hγ := (canonicalRealFlow_spec I (0 : GroupLieAlgebra
      (complexToRealModel I) G)).2.1)
    (hγ0 := hzero.1)
    (c := (0 : ℝ))
    (hδ := (canonicalRealFlow_spec I (0 : GroupLieAlgebra
      (complexToRealModel I) G)).2.1)
    (hδ0 := hzero.1)
  funext t
  simpa only [zero_smul, mul_zero, hzero.1] using (hscaled t).symm

/-- Scalar multiplication of a tangent vector is reparameterization of its
canonical flow. -/
theorem canonicalRealFlow_smul
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v : GroupLieAlgebra (complexToRealModel I) G) (c t : ℝ) :
    canonicalRealFlow I (c • v) t = canonicalRealFlow I v (t * c) := by
  have h := oneParameterSubgroup_smul_eq
    (I := complexToRealModel I)
    (hγ := (canonicalRealFlow_spec I v).2.1)
    (hγ0 := (canonicalRealFlow_spec I v).1)
    (c := c)
    (hδ := (canonicalRealFlow_spec I (c • v)).2.1)
    (hδ0 := (canonicalRealFlow_spec I (c • v)).1) t
  exact h.symm

/-- Negating a tangent vector reverses the canonical flow. -/
theorem canonicalRealFlow_neg
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v : GroupLieAlgebra (complexToRealModel I) G) (t : ℝ) :
    canonicalRealFlow I (-v) t = (canonicalRealFlow I v t)⁻¹ := by
  rw [show -v = (-1 : ℝ) • v by simp]
  rw [canonicalRealFlow_smul I v (-1) t]
  simpa only [mul_neg, mul_one] using
    (IsMIntegralCurve.map_neg_eq_inv (I := complexToRealModel I)
      (canonicalRealFlow_spec I v).2.1
      (canonicalRealFlow_spec I v).1 t)

end Analytic
end Mumford
