/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexLieAdjoint
import Mathlib.Algebra.Group.Commute.Basic
import Mathlib.Algebra.Group.Subgroup.Lattice

/-!
# The integration interface for compact complex Lie groups

The compact-holomorphic argument in `ComplexLieAdjoint` makes the derivative
of every conjugation map equal to the identity.  Mathlib does not currently
provide the Lie exponential or the theorem integrating this derivative.  This
file records that missing input explicitly and proves the remaining algebraic
step.  The resulting theorems are conditional interfaces: they do not assert
the existence of an exponential for an arbitrary Lie group.
-/

set_option autoImplicit false

noncomputable section

open scoped Manifold ContDiff

namespace Mumford
namespace Analytic

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I ⊤ G]

/-!
### Explicit exponential boundary

`exponential_generates` is the source-level local-generation conclusion used
in Mumford's commutativity argument.  The `conjugation_exp` field is the
functoriality of the exponential under conjugation; its right-hand side uses
the independently proved adjoint map.
-/

/-- The part of a Lie exponential argument needed to integrate adjoint
triviality.  This is an explicit conditional interface, not an existence
claim for Lie exponentials. -/
structure ComplexLieExponentialData where
  /-- The candidate exponential in fixed tangent coordinates. -/
  exponential : E → G
  /-- The exponential takes the zero tangent vector to the identity. -/
  exponential_zero : exponential 0 = 1
  /-- The exponential image generates the whole group. -/
  exponential_generates :
    Subgroup.closure (Set.range exponential) = (⊤ : Subgroup G)
  /-- Conjugation transports exponential points by the adjoint derivative. -/
  conjugation_exp : ∀ (x : G) (v : E),
    complexLieConjugation x (exponential v) =
      exponential ((complexLieAdjoint (G := G) I x) v)

namespace ComplexLieExponentialData

@[simp]
theorem exponential_zero_apply
    (d : ComplexLieExponentialData (E := E) (H := H) (G := G) I) :
    d.exponential 0 = 1 :=
  d.exponential_zero

end ComplexLieExponentialData

/-!
### The algebraic generation step
-/

/-- A central generating subset forces a group to be commutative.

The proof uses subgroup closure induction, so the generation hypothesis is
strictly weaker than surjectivity of the chosen parametrization.
-/
theorem isMulCommutative_of_central_generators
    {G : Type*} [Group G] {s : Set G}
    (hcentral : ∀ z ∈ s, ∀ x : G, Commute x z)
    (hgen : Subgroup.closure s = (⊤ : Subgroup G)) :
    IsMulCommutative G := by
  apply isMulCommutative_iff.mpr
  intro x y
  have hc : ∀ z ∈ Subgroup.closure s, Commute x z := by
    intro z hz
    induction hz using Subgroup.closure_induction with
    | mem z hz => exact hcentral z hz x
    | one => exact Commute.one_right x
    | mul a b ha hb h₁ h₂ => exact h₁.mul_right h₂
    | inv a ha h₁ => exact h₁.inv_right
  have hy : y ∈ Subgroup.closure s := by
    rw [hgen]
    exact Set.mem_univ y
  exact hc y hy

/-!
### Consuming the adjoint producer
-/

/-- Every point is fixed by conjugation once the explicit exponential boundary
is supplied and the compact adjoint map is trivial. -/
theorem complexLieConjugation_eq_self_of_exponential
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G]
    (d : ComplexLieExponentialData (E := E) (H := H) (G := G) I) (x y : G) :
    complexLieConjugation x y = y := by
  have hcentral : ∀ z ∈ Set.range d.exponential, ∀ a : G, Commute a z := by
    intro z hz
    obtain ⟨v, rfl⟩ := hz
    intro a
    apply (commute_iff_eq a (d.exponential v)).2
    calc
      a * d.exponential v =
          (a * d.exponential v * a⁻¹) * a := by simp [mul_assoc]
      _ = d.exponential ((complexLieAdjoint (G := G) I a) v) * a := by
        have hconj := d.conjugation_exp a v
        change a * d.exponential v * a⁻¹ =
          d.exponential ((complexLieAdjoint (G := G) I a) v) at hconj
        rw [hconj]
      _ = d.exponential v * a := by
        rw [complexLieAdjoint_eq_id (G := G) I a]
        rfl
  have hgen : Subgroup.closure (Set.range d.exponential) = (⊤ : Subgroup G) :=
    d.exponential_generates
  have hcomm : Commute x y := by
    have hmul : IsMulCommutative G :=
      isMulCommutative_of_central_generators hcentral hgen
    exact (isMulCommutative_iff.mp hmul) x y
  change x * y * x⁻¹ = y
  exact hcomm.mul_inv_cancel

/-- The compact connected complex Lie group is commutative under the explicit
exponential boundary. -/
theorem complexLieGroup_isMulCommutative_of_exponential
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G]
    (d : ComplexLieExponentialData (E := E) (H := H) (G := G) I) :
    IsMulCommutative G := by
  apply isMulCommutative_iff.mpr
  intro x y
  have h := complexLieConjugation_eq_self_of_exponential
    (G := G) I d x y
  change x * y * x⁻¹ = y at h
  calc
    x * y = (x * y * x⁻¹) * x := by simp [mul_assoc]
    _ = y * x := by rw [h]

end Analytic
end Mumford
